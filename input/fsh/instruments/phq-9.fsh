// PHQ-9 — Patient Health Questionnaire-9
//
// PRO Library 0.1.0 — derivedFrom MII PRO 2026.3.0
//
// First demonstration instrument for the 0.x line. Faithful overlay on
// upstream MII PRO mii-qst-pro-phq-9 v2026.3.0:
//   - new canonical URL under fhir.bih-charite.de/pro-library namespace
//   - new SemVer (0.1.0) replacing CalVer (2026.3.0)
//   - explicit copyright + provenance declared via Provenance resource
//   - upstream linkIds, item structure, answerOption codings preserved
//
// PHQ-9 is freely available for clinical and research use; attribution
// required (see copyright field).

RuleSet: PhqFreqOption(ord, code, display)
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = {ord}
* answerOption[=].valueCoding = $LOINC#{code} "{display}"

RuleSet: PhqFreqOptions
* insert PhqFreqOption(0, LA6568-5, Not at all)
* insert PhqFreqOption(1, LA6569-3, Several days)
* insert PhqFreqOption(2, LA6570-1, More than half the days)
* insert PhqFreqOption(3, LA6571-9, Nearly every day)

RuleSet: PhqDifficultyOptions
* answerOption[+].valueCoding = $LOINC#LA6572-7 "Not difficult at all"
* answerOption[+].valueCoding = $LOINC#LA6573-5 "Somewhat difficult"
* answerOption[+].valueCoding = $LOINC#LA6575-0 "Very difficult"
* answerOption[+].valueCoding = $LOINC#LA6574-3 "Extremely difficult"


Instance: phq-9
InstanceOf: Questionnaire
Usage: #definition
Description: "PRO Library 0.1.0 — Patient Health Questionnaire-9 (PHQ-9), derivedFrom MII PRO 2026.3.0."

* id = "phq-9"
* url = "https://fhir.bih-charite.de/pro-library/Questionnaire/phq-9"
* version = "0.1.0"
* derivedFrom = "https://www.medizininformatik-initiative.de/fhir/ext/modul-pro/Questionnaire/mii-qst-pro-phq-9|2026.3.0"
* title = "Patient Health Questionnaire-9 (PHQ-9)"
* name = "PHQ9"
* status = #draft
* experimental = false
* date = "2026-05-16"
* publisher = "BIH-CEI (provisional steward)"
* description = "Patient Health Questionnaire (PHQ-9). Nine-item depression screening instrument with an additional functional impact item."
* copyright = """
FHIR encoding © 2026 BIH-CEI. Released under CC-BY-4.0.
Original instrument: Kroenke K, Spitzer RL, Williams JBW. The PHQ-9: validity of a brief depression severity measure. J Gen Intern Med 2001;16(9):606-13. doi:10.1046/j.1525-1497.2001.016009606.x
PHQ-9 is freely available for clinical and research use; attribution required.
"""
* identifier[+].system = "https://fhir.bih-charite.de/pro-library/identifier"
* identifier[=].value = "phq-9"

* code = $LOINC#44249-1 "PHQ-9 quick depression assessment panel [Reported.PHQ]"

// Item 1: Display — recall period instruction
* item[+].linkId = "PHQ-9.Description"
* item[=].type = #display
* item[=].text = "Over the last two weeks, how often have you been bothered by any of the following problems?"
* item[=].extension[0].url = $translation
* item[=].extension[0].extension[0].url = "lang"
* item[=].extension[0].extension[0].valueCode = #de
* item[=].extension[0].extension[1].url = "content"
* item[=].extension[0].extension[1].valueString = "Wie oft fühlten Sie sich im Verlauf der letzten 2 Wochen durch die folgenden Beschwerden beeinträchtigt?"

// Items 2-10: PHQ-9 questions Q1-Q9 with shared 4-point frequency scale
* item[+].linkId = "phq-phq9-q01"
* item[=].type = #choice
* item[=].text = "Little interest or pleasure in doing things"
* item[=].insert PhqFreqOptions

* item[+].linkId = "phq-phq9-q02"
* item[=].type = #choice
* item[=].text = "Feeling down, depressed, or hopeless"
* item[=].insert PhqFreqOptions

* item[+].linkId = "phq-phq9-q03"
* item[=].type = #choice
* item[=].text = "Trouble falling or staying asleep, or sleeping too much"
* item[=].insert PhqFreqOptions

* item[+].linkId = "phq-phq9-q04"
* item[=].type = #choice
* item[=].text = "Feeling tired or having little energy"
* item[=].insert PhqFreqOptions

* item[+].linkId = "phq-phq9-q05"
* item[=].type = #choice
* item[=].text = "Poor appetite or overeating"
* item[=].insert PhqFreqOptions

* item[+].linkId = "phq-phq9-q06"
* item[=].type = #choice
* item[=].text = "Feeling bad about yourself - or that you are a failure or have let yourself or your family down"
* item[=].insert PhqFreqOptions

* item[+].linkId = "phq-phq9-q07"
* item[=].type = #choice
* item[=].text = "Trouble concentrating on things, such as reading the newspaper or watching television"
* item[=].insert PhqFreqOptions

* item[+].linkId = "phq-phq9-q08"
* item[=].type = #choice
* item[=].text = "Moving or speaking so slowly that other people could have noticed - or the opposite, being so fidgety or restless that you have been moving around a lot more than usual"
* item[=].insert PhqFreqOptions

* item[+].linkId = "phq-phq9-q09"
* item[=].type = #choice
* item[=].text = "Thoughts that you would be better off dead or of hurting yourself in some way"
* item[=].insert PhqFreqOptions

// Item 11: PHQ-9 total sum-score (decimal). Computed via SDC calculatedExpression
// (sum of ordinal values from Q1-Q9). The expression is left as upstream-MII-PRO
// for now; see TODO below for the explicit FHIRPath translation work.
* item[+].linkId = "phq-phq9-score-total"
* item[=].type = #decimal
* item[=].text = "PHQ-9 Total Score"
* item[=].readOnly = true
// TODO(0.2.0): port the upstream calculatedExpression FHIRPath verbatim and
// add a unit test (CQL Library will follow in 0.3.0).

// Item 12: Functional impact — different 4-point scale
* item[+].linkId = "phq-phq9-q10"
* item[=].type = #choice
* item[=].text = "If you checked off any problems, how difficult have these problems made it for you to do your work, take care of things at home, or get along with other people?"
* item[=].insert PhqDifficultyOptions

// Item 13: PROMIS Depression T-Score derivation. Decimal, read-only.
// TODO(0.2.0): port the upstream PROMIS-conversion table reference.
* item[+].linkId = "phq-phq9-promis-tscore"
* item[=].type = #decimal
* item[=].text = "PROMIS Depression T-Score (derived from PHQ-9)"
* item[=].readOnly = true
