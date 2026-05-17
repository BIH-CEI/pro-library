// ObservationDefinition — PROMIS Emotional Distress – Depression T-Score
//
// Shared OD across all source instruments that derive a PROMIS Depression
// T-Score (PHQ-9 via PROsetta cross-walk, PROMIS SF-4a directly, future
// PROMIS short forms). Identified by LOINC 77861-3 — one Observation
// shape regardless of the source Questionnaire.
//
// Adds clinical severity bands to the MII PRO upstream OD (which carries
// only population reference ranges from the EHIS wave 3 study, no
// interpretive bands). Bands per the PROMIS Health Measures guidance for
// higher-symptom domains: <55 within normal limits, 55-<60 mild,
// 60-<70 moderate, ≥70 severe.

CodeSystem: PROMISDepressionTScoreSeverityCS
Id: promis-depression-tscore-severity
Title: "PROMIS Depression T-Score Severity Bands"
Description: "PROMIS Health Measures interpretation bands for higher-symptom domains applied to the Depression T-score."
* ^url = "https://fhir.bih-charite.de/pro-library/CodeSystem/promis-depression-tscore-severity"
* ^version = "0.1.3"
* ^status = #active
* ^experimental = true
* ^content = #complete
* ^caseSensitive = true
* #within-normal-limits "Within normal limits" "T-score below 55 — symptoms within population norm"
* #mild                 "Mild"                 "T-score 55 to <60"
* #moderate             "Moderate"             "T-score 60 to <70"
* #severe               "Severe"               "T-score 70 or above"


Instance: cei-obsdef-promis-depression-tscore
InstanceOf: ObservationDefinition
Usage: #definition
Description: "ObservationDefinition for the PROMIS Depression T-score with clinical severity bands (PROMIS Health Measures conventions)."

* id = "cei-obsdef-promis-depression-tscore"

* extension[+].url = "http://hl7.org/fhir/StructureDefinition/cqf-citation"
* extension[=].valueString = "PROMIS Health Measures Score Cut Points: HealthMeasures.net interpretation guidance for PROMIS higher-symptom-better-score domains (within-normal-limits / mild / moderate / severe at T 55, 60, 70)."
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/cqf-citation"
* extension[=].valueString = "Derived from MII PRO mii-obsdef-pro-depression-t-score (2026.3.0); adds clinical interpretation bands. Population reference ranges from MII PRO upstream retained — see EHIS wave 3 (Riazy et al., JAMA Netw Open 2025;8(6):e2517394)."

* category[+].coding[+] = $observation-category#survey

* code = $LOINC#77861-3 "PROMIS emotional distress - depression - version 1.0 Tscore"
* permittedDataType[+] = #Quantity
* multipleResultsAllowed = false

* method.text = "PROMIS Depression T-score derived from any PROMIS-calibrated depression measure (PROMIS SF-4a, SF-8a; PHQ-9 via PROsetta Stone cross-walk; BDI-II/CES-D via PROsetta)."

* quantitativeDetails.unit = $ucum#{score}
* quantitativeDetails.decimalPrecision = 1

// Population reference ranges retained from MII PRO upstream
// (EHIS wave 3, Riazy et al. 2025) — category=reference, NOT absolute,
// so consumers know these are descriptive not diagnostic.
* qualifiedInterval[+].category = #reference
* qualifiedInterval[=].range.low = 41.8 '{score}'
* qualifiedInterval[=].range.high = 51.5 '{score}'
* qualifiedInterval[=].context.text = "German general population — EHIS wave 3 (n=22,996): Mean 46.5 (SD 7.7), Median 45.5"

* qualifiedInterval[+].category = #reference
* qualifiedInterval[=].range.low = 39.11 '{score}'
* qualifiedInterval[=].range.high = 51.68 '{score}'
* qualifiedInterval[=].context.text = "Overall European population median (IQR) — EHIS wave 3, 29 countries (n=287,530)"

// Clinical severity bands (PROMIS Health Measures conventions, higher = worse)
* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.high = 54.99 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/promis-depression-tscore-severity#within-normal-limits "Within normal limits"
* qualifiedInterval[=].condition = "T-score < 55 — within population-normal range"

* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.low = 55 '{score}'
* qualifiedInterval[=].range.high = 59.99 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/promis-depression-tscore-severity#mild "Mild"
* qualifiedInterval[=].condition = "Mild elevation"

* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.low = 60 '{score}'
* qualifiedInterval[=].range.high = 69.99 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/promis-depression-tscore-severity#moderate "Moderate"
* qualifiedInterval[=].condition = "Moderate elevation"

* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.low = 70 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/promis-depression-tscore-severity#severe "Severe"
* qualifiedInterval[=].condition = "Severe elevation"
