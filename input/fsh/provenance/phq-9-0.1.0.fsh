// Provenance for PHQ-9 PRO Library v0.1.0
//
// Records the editorial actions that produced the v0.1.0 release of phq-9:
// derivation source (MII PRO 2026.3.0), original instrument bibliographic
// reference (Kroenke et al. 2001), agents involved.
//
// 0.1.0 has provisional approver attribution (BIH-CEI editorial process is
// not formalised yet); 1.0.0 will list the named editorial board members.

Instance: phq-9-0-1-0-provenance
InstanceOf: Provenance
Usage: #definition
Description: "Provenance record for PRO Library PHQ-9 v0.1.0 release."

* id = "phq-9-0-1-0-provenance"
* target[+].reference = "Questionnaire/phq-9"
* target[=].display = "PHQ-9 (PRO Library v0.1.0)"

* occurredDateTime = "2026-05-16"
* recorded = "2026-05-16T12:00:00Z"

* agent[+].type = $provenance-participant#author
* agent[=].who.display = "BIH-CEI PRO Library editorial (provisional)"

// Source 1 — upstream derivation
* entity[+].role = #source
* entity[=].what.display = "MII PRO mii-qst-pro-phq-9 v2026.3.0 (FHIR upstream)"
* entity[=].what.identifier.system = "https://www.medizininformatik-initiative.de/fhir/ext/modul-pro/Questionnaire"
* entity[=].what.identifier.value = "mii-qst-pro-phq-9|2026.3.0"

// Source 2 — original instrument publication (the bibliographic anchor)
* entity[+].role = #source
* entity[=].what.display = "Kroenke K, Spitzer RL, Williams JBW. The PHQ-9: validity of a brief depression severity measure. J Gen Intern Med 2001;16(9):606-13."
* entity[=].what.identifier.system = "https://doi.org"
* entity[=].what.identifier.value = "10.1046/j.1525-1497.2001.016009606.x"
