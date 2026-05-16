// CQL library identifier matches the FHIR Library resource id so that
// HAPI CR's Library/{id}/$evaluate URL-based resolver can find this source.
library "phq-9-scoring" version '0.1.2'

/*
 * PHQ-9 scoring + PROMIS Depression T-Score derivation.
 *
 * 0.1.2 — SDC Flow A redesign.
 * Switched from `parameter "Response" QuestionnaireResponse` (Flow B — direct
 * Library/$evaluate testing) to `context Patient` + retrieve from server data.
 * The retrieve pattern is what HAPI CR's SDC-style $populate / $extract /
 * sdc-calculatedExpression evaluation flow expects, and it works around the
 * library-parameter-passing bug we hit in 0.1.1.
 *
 * Original instrument: Kroenke K, Spitzer RL, Williams JBW. The PHQ-9.
 *   J Gen Intern Med 2001;16(9):606-13. doi:10.1046/j.1525-1497.2001.016009606.x
 * PROMIS Depression T-Score lookup: PROsetta Stone cross-walk
 *   (Choi SW et al. Psychol Assess 2014;26(2):513-27.)
 *
 * CQL spec authority: https://cql.hl7.org/
 */

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

context Patient

// Most-recent completed PHQ-9 response for the context Patient.
// Filter strategy: use .startsWith on the canonical's string value to be
// version-agnostic (matches 'phq-9|0.1.0', 'phq-9|0.1.1', 'phq-9|0.1.2', etc.).
// The `~` canonical-equivalence operator in CQL is finicky for partial matches.
define "PHQ9QuestionnaireUrl":
  'https://fhir.bih-charite.de/pro-library/Questionnaire/phq-9'

define "MostRecentResponse":
  First(
    ([QuestionnaireResponse]) R
      where R.questionnaire.value.startsWith(PHQ9QuestionnaireUrl)
      sort by authored desc
  )

// LinkIds of the 9 PHQ items we score (Q10 functional-impact excluded).
define "ScoredLinkIds":
  { 'phq-phq9-q01', 'phq-phq9-q02', 'phq-phq9-q03',
    'phq-phq9-q04', 'phq-phq9-q05', 'phq-phq9-q06',
    'phq-phq9-q07', 'phq-phq9-q08', 'phq-phq9-q09' }

// Ordinal value for one PHQ-9 frequency-scale answer code.
//   LA6568-5 "Not at all"               = 0
//   LA6569-3 "Several days"             = 1
//   LA6570-1 "More than half the days"  = 2
//   LA6571-9 "Nearly every day"         = 3
define function "OrdinalForCode"(code String):
  case code
    when 'LA6568-5' then 0
    when 'LA6569-3' then 1
    when 'LA6570-1' then 2
    when 'LA6571-9' then 3
    else 0
  end

// Sum of ordinal values across the 9 scored items → 0..27.
// Returns null if no response is found for the patient.
// CQL `return` clause defaults to DISTINCT — without `return all`, identical
// ordinals (e.g. 9× LA6571-9 → 9× 3) collapse to a single value [3] and
// Sum returns 3 instead of 27. The `all` modifier preserves duplicates.
// (Cost us an hour. Now captured in the cql-development skill.)
define "PHQ9TotalScore":
  Sum(
    ( MostRecentResponse.item ) I
      where I.linkId in "ScoredLinkIds"
      return all OrdinalForCode(
        ((First(I.answer).value) as FHIR.Coding).code.value
      )
  )

// Severity band per Kroenke 2001 cut-points.
define "PHQ9Severity":
  case
    when PHQ9TotalScore between 0 and 4 then 'minimal'
    when PHQ9TotalScore between 5 and 9 then 'mild'
    when PHQ9TotalScore between 10 and 14 then 'moderate'
    when PHQ9TotalScore between 15 and 19 then 'moderately severe'
    when PHQ9TotalScore between 20 and 27 then 'severe'
    else null
  end

// PROMIS Depression T-Score from raw score (PROsetta Stone cross-walk).
// Identical to the FHIRPath lookup table in MII PRO upstream.
define "PROMISDepressionTScore":
  case PHQ9TotalScore
    when  0 then 37.4
    when  1 then 42.7
    when  2 then 45.9
    when  3 then 48.3
    when  4 then 50.5
    when  5 then 52.5
    when  6 then 54.2
    when  7 then 55.8
    when  8 then 57.2
    when  9 then 58.6
    when 10 then 59.9
    when 11 then 61.1
    when 12 then 62.3
    when 13 then 63.5
    when 14 then 64.7
    when 15 then 65.8
    when 16 then 66.9
    when 17 then 68.0
    when 18 then 69.2
    when 19 then 70.3
    when 20 then 71.5
    when 21 then 72.7
    when 22 then 74.0
    when 23 then 75.3
    when 24 then 76.7
    when 25 then 78.3
    when 26 then 80.0
    when 27 then 82.3
    else null
  end
