// CQL library identifier matches the FHIR Library resource id.
library "promis-depression-sf4a-scoring" version '0.1.3'

/*
 * PROMIS Emotional Distress – Depression Short Form 4a — scoring.
 *
 * 4 items (promis-eddep04/06/29/41), each 5-point Likert (1..5):
 *   LA6270-8 Never          = 1
 *   LA10066-1 Rarely        = 2
 *   LA10082-8 Sometimes     = 3
 *   LA10044-8 Often         = 4
 *   LA9933-8 Always         = 5
 *
 * Raw sum:  4..20  (LOINC 77821-7)
 * T-Score: 41.0..79.4, lookup table per PROMIS SF-4a scoring manual
 *          (LOINC 77861-3 — same code as PHQ-9-derived T, since both
 *          represent the PROMIS Depression T metric)
 *
 * Library ported from FHIRPath calculatedExpression in MII PRO upstream
 * mii-qst-pro-promis-depression-sf4a (de.medizininformatikinitiative.
 * kerndatensatz.pros 2026.3.0).
 *
 * SDC Flow A (context Patient + retrieve) — same architecture as PHQ-9.
 */

using FHIR version '4.0.1'

include FHIRHelpers version '4.0.1'

parameter "Response" QuestionnaireResponse

context Patient

define "SF4aQuestionnaireUrl":
  'https://fhir.bih-charite.de/pro-library/Questionnaire/promis-depression-sf4a'

define "MostRecentResponse":
  First(
    ([QuestionnaireResponse]) R
      where R.questionnaire.value.startsWith(SF4aQuestionnaireUrl)
      sort by authored desc
  )

define "ScoredLinkIds":
  { 'promis-eddep04', 'promis-eddep06', 'promis-eddep29', 'promis-eddep41' }

define function "OrdinalForCode"(code String):
  case code
    when 'LA6270-8'  then 1   // Never
    when 'LA10066-1' then 2   // Rarely
    when 'LA10082-8' then 3   // Sometimes
    when 'LA10044-8' then 4   // Often
    when 'LA9933-8'  then 5   // Always
    else 0
  end

define "PROMISDepressionSF4aRawScore":
  Sum(
    ( MostRecentResponse.item ) I
      where I.linkId in "ScoredLinkIds"
      return all OrdinalForCode(
        ((First(I.answer).value) as FHIR.Coding).code.value
      )
  )

// PROMIS Depression T-Score from SF-4a raw score (PROMIS scoring manual).
// Range: raw 4 → T 41.0  ..  raw 20 → T 79.4
define "PROMISDepressionSF4aTScore":
  case PROMISDepressionSF4aRawScore
    when  4 then 41.0
    when  5 then 49.0
    when  6 then 51.8
    when  7 then 53.9
    when  8 then 55.7
    when  9 then 57.3
    when 10 then 58.9
    when 11 then 60.5
    when 12 then 62.2
    when 13 then 63.9
    when 14 then 65.7
    when 15 then 67.5
    when 16 then 69.4
    when 17 then 71.2
    when 18 then 73.3
    when 19 then 75.7
    when 20 then 79.4
    else null
  end
