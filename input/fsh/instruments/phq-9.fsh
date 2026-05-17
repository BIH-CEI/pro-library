// PHQ-9 — Patient Health Questionnaire-9
//
// PRO Library 0.1.3 — derivedFrom MII PRO 2026.3.0
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

RuleSet: PhqFreqOptions
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 0
* answerOption[=].valueCoding = $LOINC#LA6568-5 "Not at all"
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 1
* answerOption[=].valueCoding = $LOINC#LA6569-3 "Several days"
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 2
* answerOption[=].valueCoding = $LOINC#LA6570-1 "More than half the days"
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 3
* answerOption[=].valueCoding = $LOINC#LA6571-9 "Nearly every day"

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
* version = "0.1.3"
* derivedFrom = "https://www.medizininformatik-initiative.de/fhir/ext/modul-pro/Questionnaire/mii-qst-pro-phq-9|2026.3.0"
* title = "Patient Health Questionnaire-9 (PHQ-9)"
* name = "PHQ9"
// status=active per FHIR semantics: PHQ-9 itself is a stable validated
// instrument (Kroenke 2001). The 0.x instability is at the library/
// manifest framing level — captured via experimental=true + version <1.0.0.
// (status=draft would be rejected by HAPI's PackageInstallerSvc on auto-install
// anyway, mirroring the SDC IG issue.)
* status = #active
* experimental = true
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

// CRMI tier claims — Shareable + Computable + Executable for 0.1.1.
// (Bumped to executable since 0.1.1 binds the CQL Library that makes
// scoring runnable via Library/$evaluate and $extract.)
// Publishable deferred to 0.2.0+ (requires formalised editorial process
// metadata: contact, approvalDate, effectivePeriod).
* extension[+].url = $cqf-knowledgeCapability
* extension[=].valueCode = #shareable
* extension[+].url = $cqf-knowledgeCapability
* extension[=].valueCode = #computable
* extension[+].url = $cqf-knowledgeCapability
* extension[=].valueCode = #executable
* extension[+].url = $cqf-knowledgeRepresentationLevel
* extension[=].valueCode = #executable

// Bind the scoring CQL Library. Score items below reference its functions
// via sdc-calculatedExpression with language=text/cql-identifier.
// Pure CQL by policy — no FHIRPath fallback. Renderers must support CQL to
// claim the MII PRO `calculatable` capability against this Questionnaire.
* extension[+].url = $cqf-library
* extension[=].valueCanonical = "https://fhir.bih-charite.de/pro-library/Library/phq-9-scoring|0.1.3"

* code = $LOINC#44249-1 "PHQ-9 quick depression assessment panel [Reported.PHQ]"

// Item 1: Display — recall period instruction
// Translation extension lives on `text` (a primitive) — emitted as
// `_text.extension[]` in JSON. The translation extension SD allows only
// e:string / e:code / e:markdown — attaching to the `item` BackboneElement
// directly is non-conformant (HAPI validator rejects).
* item[+]
  * linkId = "PHQ-9.Description"
  * type = #display
  * text = "Over the last two weeks, how often have you been bothered by any of the following problems?"
  * text.extension[+].url = $translation
  * text.extension[=].extension[+].url = "lang"
  * text.extension[=].extension[=].valueCode = #de
  * text.extension[=].extension[+].url = "content"
  * text.extension[=].extension[=].valueString = "Wie oft fühlten Sie sich im Verlauf der letzten 2 Wochen durch die folgenden Beschwerden beeinträchtigt?"

// Items 2-10: PHQ-9 questions Q1-Q9 with shared 4-point frequency scale
* item[+]
  * linkId = "phq-phq9-q01"
  * type = #choice
  * text = "Little interest or pleasure in doing things"
  * insert PhqFreqOptions

* item[+]
  * linkId = "phq-phq9-q02"
  * type = #choice
  * text = "Feeling down, depressed, or hopeless"
  * insert PhqFreqOptions

* item[+]
  * linkId = "phq-phq9-q03"
  * type = #choice
  * text = "Trouble falling or staying asleep, or sleeping too much"
  * insert PhqFreqOptions

* item[+]
  * linkId = "phq-phq9-q04"
  * type = #choice
  * text = "Feeling tired or having little energy"
  * insert PhqFreqOptions

* item[+]
  * linkId = "phq-phq9-q05"
  * type = #choice
  * text = "Poor appetite or overeating"
  * insert PhqFreqOptions

* item[+]
  * linkId = "phq-phq9-q06"
  * type = #choice
  * text = "Feeling bad about yourself - or that you are a failure or have let yourself or your family down"
  * insert PhqFreqOptions

* item[+]
  * linkId = "phq-phq9-q07"
  * type = #choice
  * text = "Trouble concentrating on things, such as reading the newspaper or watching television"
  * insert PhqFreqOptions

* item[+]
  * linkId = "phq-phq9-q08"
  * type = #choice
  * text = "Moving or speaking so slowly that other people could have noticed - or the opposite, being so fidgety or restless that you have been moving around a lot more than usual"
  * insert PhqFreqOptions

* item[+]
  * linkId = "phq-phq9-q09"
  * type = #choice
  * text = "Thoughts that you would be better off dead or of hurting yourself in some way"
  * insert PhqFreqOptions

// Item 11: PHQ-9 total sum-score (decimal). Computed via CQL function
// PHQ9.PHQ9TotalScore in the bound scoring Library. LOINC item.code allows
// $extract to produce an Observation that conforms (by matching .code) to
// the MII PRO ObservationDefinition mii-obsdef-pro-score-phq-9.
* item[+]
  * linkId = "phq-phq9-score-total"
  * type = #decimal
  * text = "PHQ-9 Total Score"
  * readOnly = true
  * code = $LOINC#44261-6 "Patient Health Questionnaire 9 item (PHQ-9) total score [Reported]"
  * extension[+].url = $sdc-calculatedExpression
  * extension[=].valueExpression.name = "phq9-total-score"
  * extension[=].valueExpression.language = #text/cql-identifier
  * extension[=].valueExpression.expression = "PHQ9TotalScore"
  * extension[+].url = $observation-extract
  * extension[=].valueBoolean = true
  * extension[+].url = $sdc-observation-extract-category
  * extension[=].valueCodeableConcept = $observation-category#survey
  * extension[+].url = $questionnaire-unit
  * extension[=].valueCoding = $ucum#{score}

// Item 12: Functional impact — different 4-point scale
* item[+]
  * linkId = "phq-phq9-q10"
  * type = #choice
  * text = "If you checked off any problems, how difficult have these problems made it for you to do your work, take care of things at home, or get along with other people?"
  * insert PhqDifficultyOptions

// Item 13: PROMIS Depression T-Score derivation via CQL function
// PHQ9.PROMISDepressionTScore (PROsetta Stone cross-walk). LOINC item.code
// 77861-3 matches MII PRO ObservationDefinition mii-obsdef-pro-depression-t-score
// so $extract produces a conforming Observation.
* item[+]
  * linkId = "phq-phq9-promis-tscore"
  * type = #decimal
  * text = "PROMIS Depression T-Score (derived from PHQ-9)"
  * readOnly = true
  * code = $LOINC#77861-3 "PROMIS emotional distress - depression - version 1.0 Tscore"
  * extension[+].url = $sdc-calculatedExpression
  * extension[=].valueExpression.name = "promis-depression-tscore"
  * extension[=].valueExpression.language = #text/cql-identifier
  * extension[=].valueExpression.expression = "PROMISDepressionTScore"
  * extension[+].url = $observation-extract
  * extension[=].valueBoolean = true
  * extension[+].url = $sdc-observation-extract-category
  * extension[=].valueCodeableConcept = $observation-category#survey
  * extension[+].url = $questionnaire-unit
  * extension[=].valueCoding = $ucum#{score}
