// PRO Library Release 0.1.0 Manifest
//
// CRMI Library of type=asset-collection. Pins the exact version of every
// artefact bundled in the 0.1.0 release. Consumers fetch via:
//
//   GET [base]/Questionnaire/$package?manifest=
//     https://fhir.bih-charite.de/pro-library/Library/release-0-1-0
//
// and receive a deterministic, reproducible bundle of the listed artefacts.
//
// Future releases (0.2.0, 0.3.0, …) add to relatedArtifact[] as more
// instruments come online.

Instance: release-0-1-0
InstanceOf: Library
Usage: #definition
Description: "PRO Library Release 0.1.0 — first end-to-end demonstration release. Scope: PHQ-9 only."

* id = "release-0-1-0"
* url = "https://fhir.bih-charite.de/pro-library/Library/release-0-1-0"
* version = "0.1.0"
* name = "PROLibraryRelease010"
* title = "PRO Library Release 0.1.0"
* status = #draft
* experimental = false
* date = "2026-05-16"
* publisher = "BIH-CEI (provisional steward)"
* type = $library-type#asset-collection "Asset Collection"
* description = "First end-to-end demonstration release of the PRO Library. Scope intentionally minimal: one instrument (PHQ-9) derivedFrom MII PRO 2026.3.0, with companion Provenance and a should-pass test response. Demonstrates the full pipeline (FSH → SUSHI → IG Publisher → release tarball)."

// CRMI tier claim for the manifest itself
* extension[+].url = $cqf-knowledgeCapability
* extension[=].valueCode = #shareable
* extension[+].url = $cqf-knowledgeRepresentationLevel
* extension[=].valueCode = #structured

* relatedArtifact[+].type = #depends-on
* relatedArtifact[=].display = "PHQ-9 (PRO Library v0.1.0)"
* relatedArtifact[=].resource = "https://fhir.bih-charite.de/pro-library/Questionnaire/phq-9|0.1.0"
