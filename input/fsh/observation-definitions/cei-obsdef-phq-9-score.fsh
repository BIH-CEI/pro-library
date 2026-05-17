// ObservationDefinition — PHQ-9 Total Score
//
// Adds clinical severity bands to the MII PRO upstream OD (which has only
// one absolute 0-27 range). Bands per Kroenke 2001 cut-points — the same
// thresholds our CQL Library uses for the PHQ9Severity define.
//
// R4 mechanism: each band is a qualifiedInterval with category=absolute,
// range.low/high, and context.text carrying the band label. The sidecar
// uses .context.coding (preferred) or .context.text (fallback) as
// Observation.interpretation.
//
// R5 migration note: qualifiedInterval → qualifiedValue; context →
// interpretation (which is already a CodeableConcept-list). Field rename
// only; semantic model unchanged.

CodeSystem: PHQ9SeverityCS
Id: phq-9-severity
Title: "PHQ-9 Severity Bands"
Description: "Kroenke 2001 PHQ-9 cut-points: minimal / mild / moderate / moderately severe / severe."
* ^url = "https://fhir.bih-charite.de/pro-library/CodeSystem/phq-9-severity"
* ^version = "0.1.3"
* ^status = #active
* ^experimental = true
* ^content = #complete
* ^caseSensitive = true
* #minimal              "Minimal depression"           "PHQ-9 sum 0-4"
* #mild                 "Mild depression"              "PHQ-9 sum 5-9"
* #moderate             "Moderate depression"          "PHQ-9 sum 10-14"
* #moderately-severe    "Moderately severe depression" "PHQ-9 sum 15-19"
* #severe               "Severe depression"            "PHQ-9 sum 20-27"


Instance: cei-obsdef-phq-9-score
InstanceOf: ObservationDefinition
Usage: #definition
Description: "ObservationDefinition for PHQ-9 total score with Kroenke 2001 severity bands."

* id = "cei-obsdef-phq-9-score"

// Provenance via cqf-relatedArtifact (element-agnostic, structured citation
// + derivation). cqf-citation is constrained to Attachment elements in its
// StructureDefinition and cannot live on an ObservationDefinition root.
* extension[+].url = "http://hl7.org/fhir/StructureDefinition/cqf-relatedArtifact"
* extension[=].valueRelatedArtifact.type = #citation
* extension[=].valueRelatedArtifact.label = "Kroenke 2001 — PHQ-9 severity validation"
* extension[=].valueRelatedArtifact.citation = "Kroenke K, Spitzer RL, Williams JBW. The PHQ-9: validity of a brief depression severity measure. J Gen Intern Med 2001;16(9):606-13. doi:10.1046/j.1525-1497.2001.016009606.x"

* extension[+].url = "http://hl7.org/fhir/StructureDefinition/cqf-relatedArtifact"
* extension[=].valueRelatedArtifact.type = #derived-from
* extension[=].valueRelatedArtifact.label = "MII PRO upstream OD (severity bands added downstream)"
* extension[=].valueRelatedArtifact.display = "Derived from MII PRO mii-obsdef-pro-score-phq-9 (2026.3.0); adds clinical severity bands not present upstream."

* category[+].coding[+] = $observation-category#survey

* code = $LOINC#44261-6 "Patient Health Questionnaire 9 item (PHQ-9) total score [Reported]"
* permittedDataType[+] = #Quantity
* multipleResultsAllowed = false

* quantitativeDetails.unit = $ucum#{score}
* quantitativeDetails.decimalPrecision = 0

// 5 Kroenke severity bands. Mutually exclusive ranges over 0..27.
* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.low = 0 '{score}'
* qualifiedInterval[=].range.high = 4 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/phq-9-severity#minimal "Minimal depression"
* qualifiedInterval[=].condition = "Minimal symptoms"

* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.low = 5 '{score}'
* qualifiedInterval[=].range.high = 9 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/phq-9-severity#mild "Mild depression"
* qualifiedInterval[=].condition = "Mild symptoms"

* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.low = 10 '{score}'
* qualifiedInterval[=].range.high = 14 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/phq-9-severity#moderate "Moderate depression"
* qualifiedInterval[=].condition = "Moderate symptoms"

* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.low = 15 '{score}'
* qualifiedInterval[=].range.high = 19 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/phq-9-severity#moderately-severe "Moderately severe depression"
* qualifiedInterval[=].condition = "Moderately severe symptoms"

* qualifiedInterval[+].category = #absolute
* qualifiedInterval[=].range.low = 20 '{score}'
* qualifiedInterval[=].range.high = 27 '{score}'
* qualifiedInterval[=].context = https://fhir.bih-charite.de/pro-library/CodeSystem/phq-9-severity#severe "Severe depression"
* qualifiedInterval[=].condition = "Severe symptoms"
