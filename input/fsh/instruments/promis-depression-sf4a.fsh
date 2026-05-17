// PROMIS Emotional Distress — Depression Short Form 4a
//
// PRO Library 0.1.3 — derivedFrom MII PRO 2026.3.0.
// 4-item short form with 5-pt Likert (1..5).
// Same SDC Flow A architecture as phq-9: cqf-library binding + CQL
// calculatedExpression on score items.

RuleSet: SF4aLikertOptions
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 1
* answerOption[=].valueCoding = $LOINC#LA6270-8  "Never"
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 2
* answerOption[=].valueCoding = $LOINC#LA10066-1 "Rarely"
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 3
* answerOption[=].valueCoding = $LOINC#LA10082-8 "Sometimes"
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 4
* answerOption[=].valueCoding = $LOINC#LA10044-8 "Often"
* answerOption[+].extension[0].url = $ordinalValue
* answerOption[=].extension[0].valueDecimal = 5
* answerOption[=].valueCoding = $LOINC#LA9933-8  "Always"


Instance: promis-depression-sf4a
InstanceOf: Questionnaire
Usage: #definition
Description: "PRO Library 0.1.3 — PROMIS Depression Short Form 4a, derivedFrom MII PRO 2026.3.0."

* id = "promis-depression-sf4a"
* url = "https://fhir.bih-charite.de/pro-library/Questionnaire/promis-depression-sf4a"
* version = "0.1.3"
* derivedFrom = "https://www.medizininformatik-initiative.de/fhir/ext/modul-pro/Questionnaire/mii-qst-pro-promis-depression-sf4a|2026.3.0"
* title = "PROMIS Depression Short Form 4a"
* name = "PROMISDepressionSF4a"
* status = #active
* experimental = true
* date = "2026-05-17"
* publisher = "BIH-CEI (provisional steward)"
* description = "Four-item short form measuring depressive symptoms on the PROMIS Emotional Distress – Depression item bank."
* copyright = """
FHIR encoding © 2026 BIH-CEI. Released under CC-BY-4.0.
Original instrument: Pilkonis PA, Choi SW, Reise SP, Stover AM, Riley WT, Cella D. Item banks for measuring emotional distress from PROMIS: depression, anxiety, and anger. Assessment 2011;18(3):263-83. doi:10.1177/1073191111411667
PROMIS Depression item bank © PROMIS Health Organization, freely available for clinical/research use with attribution.
"""
* identifier[+].system = "https://fhir.bih-charite.de/pro-library/identifier"
* identifier[=].value = "promis-depression-sf4a"

* extension[+].url = $cqf-knowledgeCapability
* extension[=].valueCode = #shareable
* extension[+].url = $cqf-knowledgeCapability
* extension[=].valueCode = #computable
* extension[+].url = $cqf-knowledgeCapability
* extension[=].valueCode = #executable
* extension[+].url = $cqf-knowledgeRepresentationLevel
* extension[=].valueCode = #executable

* extension[+].url = $cqf-library
* extension[=].valueCanonical = "https://fhir.bih-charite.de/pro-library/Library/promis-depression-sf4a-scoring|0.1.3"

* code = $LOINC#62160-4 "PROMIS-29 profile short form set [PROMIS]"

// Display / recall-period
* item[+]
  * linkId = "PROMIS-Depression.Description"
  * type = #display
  * text = "In the past 7 days …"

// 4 PROMIS Depression items — each with LOINC item.code matching the
// individual-question codes upstream uses for trace/extract.
* item[+]
  * linkId = "promis-eddep04"
  * type = #choice
  * text = "I felt worthless"
  * code = $LOINC#61953-6
  * insert SF4aLikertOptions

* item[+]
  * linkId = "promis-eddep06"
  * type = #choice
  * text = "I felt helpless"
  * code = $LOINC#61955-1
  * insert SF4aLikertOptions

* item[+]
  * linkId = "promis-eddep29"
  * type = #choice
  * text = "I felt depressed"
  * code = $LOINC#61967-6
  * insert SF4aLikertOptions

* item[+]
  * linkId = "promis-eddep41"
  * type = #choice
  * text = "I felt hopeless"
  * code = $LOINC#61973-4
  * insert SF4aLikertOptions

// Raw sum (4..20). CQL: PROMISDepressionSF4aRawScore.
* item[+]
  * linkId = "promis-depression-score-raw"
  * type = #decimal
  * text = "PROMIS Depression SF-4a raw score"
  * readOnly = true
  * code = $LOINC#77821-7 "PROMIS short form - emotional distress - depression 4a Tscore"
  * extension[+].url = $sdc-calculatedExpression
  * extension[=].valueExpression.name = "promis-sf4a-raw"
  * extension[=].valueExpression.language = #text/cql-identifier
  * extension[=].valueExpression.expression = "PROMISDepressionSF4aRawScore"
  * extension[+].url = $observation-extract
  * extension[=].valueBoolean = true
  * extension[+].url = $sdc-observation-extract-category
  * extension[=].valueCodeableConcept = $observation-category#survey
  * extension[+].url = $questionnaire-unit
  * extension[=].valueCoding = $ucum#{score}

// T-Score via PROMIS scoring manual lookup. CQL: PROMISDepressionSF4aTScore.
* item[+]
  * linkId = "promis-depression-score-tscore"
  * type = #decimal
  * text = "PROMIS Depression T-Score (SF-4a)"
  * readOnly = true
  * code = $LOINC#77861-3 "PROMIS emotional distress - depression - version 1.0 Tscore"
  * extension[+].url = $sdc-calculatedExpression
  * extension[=].valueExpression.name = "promis-sf4a-tscore"
  * extension[=].valueExpression.language = #text/cql-identifier
  * extension[=].valueExpression.expression = "PROMISDepressionSF4aTScore"
  * extension[+].url = $observation-extract
  * extension[=].valueBoolean = true
  * extension[+].url = $sdc-observation-extract-category
  * extension[=].valueCodeableConcept = $observation-category#survey
  * extension[+].url = $questionnaire-unit
  * extension[=].valueCoding = $ucum#{score}
