// PRO Library Release 0.1.2 Manifest
//
// Adds to 0.1.0:
//   - CQL scoring Library for PHQ-9 (raw + severity band + PROMIS T-Score)
//   - PHQ-9 score items wired to CQL via sdc-calculatedExpression
//     (language=text/cql-identifier, no FHIRPath — see POLICY §11)
//   - LOINC item.codes on score items so $extract produces Observations
//     conforming to MII PRO ObservationDefinitions (44261-6 sum-score,
//     77861-3 PROMIS Depression T-Score)
//   - 10 should-pass test response fixtures (min/max + every band boundary)
//   - TestScript exercising Library/$evaluate against each fixture

Instance: release-0-1-2
InstanceOf: Library
Usage: #definition
Description: "PRO Library Release 0.1.2 — adds CQL scoring + PROMIS T-Score derivation + boundary test fixtures."

* id = "release-0-1-2"
* url = "https://fhir.bih-charite.de/pro-library/Library/release-0-1-2"
* version = "0.1.2"
* name = "PROLibraryRelease012"
* title = "PRO Library Release 0.1.2"
* status = #active
* experimental = true
* date = "2026-05-16"
* publisher = "BIH-CEI (provisional steward)"
* type = $library-type#asset-collection "Asset Collection"
* description = "Adds CQL-based scoring (sum, severity band, PROMIS T-Score) + boundary test fixtures to the 0.1.0 PHQ-9 baseline."

* extension[+].url = $cqf-knowledgeCapability
* extension[=].valueCode = #shareable
* extension[+].url = $cqf-knowledgeRepresentationLevel
* extension[=].valueCode = #structured

* relatedArtifact[+].type = #depends-on
* relatedArtifact[=].display = "PHQ-9 Questionnaire v0.1.2 (with CQL scoring bindings)"
* relatedArtifact[=].resource = "https://fhir.bih-charite.de/pro-library/Questionnaire/phq-9|0.1.2"

* relatedArtifact[+].type = #depends-on
* relatedArtifact[=].display = "PHQ-9 Scoring CQL Library v0.1.2"
* relatedArtifact[=].resource = "https://fhir.bih-charite.de/pro-library/Library/phq-9-scoring|0.1.2"

* relatedArtifact[+].type = #depends-on
* relatedArtifact[=].display = "PHQ-9 Scoring TestScript v0.1.2"
* relatedArtifact[=].resource = "https://fhir.bih-charite.de/pro-library/TestScript/phq-9-scoring-test|0.1.2"
