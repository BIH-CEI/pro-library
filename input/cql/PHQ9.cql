// CQL library identifier matches the FHIR Library resource id so that
// HAPI CR's Library/{id}/$evaluate URL-based resolver can find this source.
library "phq-9-scoring" version '0.1.1'

/*
 * PHQ-9 scoring + PROMIS Depression T-Score derivation.
 *
 * Ported from the FHIRPath calculatedExpression in MII PRO
 * mii-qst-pro-phq-9 (de.medizininformatikinitiative.kerndatensatz.pros#2026.3.0)
 * for: (a) explicit machine-readable scoring spec, (b) authoritative
 * server-side computation via Library/$evaluate, (c) testable, citable.
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

// QuestionnaireResponse passed as a $evaluate parameter. No context block —
// scoring is purely on the response payload, no Patient dependency.
parameter "Response" QuestionnaireResponse

// LinkIds of the 9 PHQ items we score (Q10 functional-impact excluded).
// Defined separately because CQL's `in` operator does not accept inline
// list literals directly inside where-clauses.
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
//
// Grammar note (cql.hl7.org/08-a-cqlsyntax.html): query clauses MUST appear
// in the order  source → let → where → return.  We inline the Coding
// extraction inside `return` so we don't need a let clause; the explicit
// parens around `(First(I.answer).value) as FHIR.Coding` are required
// because `as` binds tighter than `.code`.
// FHIRHelpers (auto-included) coerces FHIR.string I.linkId → System.String
// for the `in` membership comparison against the list of System.Strings.
define "PHQ9TotalScore":
  Sum(
    ( Response.item ) I
      where I.linkId in "ScoredLinkIds"
      return OrdinalForCode(
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
