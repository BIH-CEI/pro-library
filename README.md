# PRO Library

A curated reference source of FHIR-encoded Patient-Reported Outcome Measure (PROM) Questionnaires.

> **Status: 0.1.0 — pre-stable.**
> This is the first end-to-end demonstration release. Scope: PHQ-9 only. Expect breaking changes through the 0.x line.
>
> **Namespace is provisional.** The 0.x line uses `https://fhir.bih-charite.de/pro-library` under BIH-CEI stewardship. The 1.0.0 release may migrate the namespace if the normative authority moves elsewhere — see [`ARTIFACT_METADATA_POLICY.md`](../fhir-sdc-questionnaire-service/ARTIFACT_METADATA_POLICY.md) §2 for the migration plan.
>
> **No claim to normative authority.** See [`VISION.md`](../fhir-sdc-questionnaire-service/VISION.md) §1a — this work builds the *infrastructure* a future normative authority would need; it does not itself hold that authority.

## What this is

Companion content repository to the [fhir-sdc-questionnaire-service](../fhir-sdc-questionnaire-service) Form Manager. The Form Manager runs the distribution layer (container, REST, syndication, NPM); this repository holds the content (FSH-authored Questionnaires, ValueSets, CodeSystems, manifests, scoring libraries, test corpora).

| Aspect | Approach |
|---|---|
| Versioning | SemVer per artefact, starting at `0.1.0` for the 0.x demonstration line |
| Relationship to MII PRO | First-version artefacts are `derivedFrom` MII PRO 2026.3.0 with versioned upstream canonicals (`...|2026.3.0`) |
| Release primitive | CRMI `Library` resource of `type = asset-collection` (a "manifest"), pinning per-artefact versions |
| Build tooling | [SUSHI](https://fshschool.org/) + [HL7 IG Publisher](https://github.com/HL7/fhir-ig-publisher) |
| Validation | Companion `pro-library-validator` container (planned, see VISION.md WP8b) |

## Repository layout

```
pro-library/
├── sushi-config.yaml             SUSHI configuration (id, canonical, deps)
├── ig.ini                        IG Publisher configuration
├── input/
│   ├── fsh/
│   │   ├── instruments/          Per-instrument Questionnaire FSH (one file each)
│   │   ├── manifests/            Release manifests (asset-collection Library)
│   │   ├── provenance/           Per-artefact Provenance records
│   │   └── profiles/             (planned 0.2.0+) cei-* profile set
│   ├── data/                     Test fixtures (should-pass / should-fail QResponses)
│   └── pagecontent/              IG narrative
└── .github/workflows/            CI: SUSHI build, IG Publisher run, release tarball
```

## Build locally

```bash
# Install SUSHI (Node.js required)
npm install -g fsh-sushi

# Run SUSHI — produces fsh-generated/resources/*.json from input/fsh/**
sushi .

# (Optional) Run the HL7 IG Publisher for the full IG website
curl -sfL https://github.com/HL7/fhir-ig-publisher/releases/latest/download/publisher.jar \
     -o publisher.jar
java -jar publisher.jar -ig .
# Output lands in output/
```

## What's in 0.1.0

- **PHQ-9** (`Questionnaire/phq-9`) — `derivedFrom` MII PRO `mii-qst-pro-phq-9|2026.3.0`
- **Release manifest** (`Library/release-0-1-0`) — asset-collection pinning PHQ-9 v0.1.0
- **Provenance** for the PHQ-9 0.1.0 release
- **One should-pass test response**

## What's NOT in 0.1.0 (deliberately)

- Other instruments (GAD-7, EORTC, EQ-5D, …) — coming in 0.2.0+
- Profile set (`cei-shareable-pro-questionnaire`, etc.) — coming in 0.2.0+
- Scoring CQL libraries — separate workstream
- ConceptMaps for non-FHIR-capture transcoding — 0.3.0+
- Signed releases — pre-1.0
- License-gated distribution / mTLS — pre-1.0

## Related repositories

- [`fhir-sdc-questionnaire-service`](../fhir-sdc-questionnaire-service) — the Form Manager (distribution runtime). Loads this PRO Library alongside MII PRO; serves it via container, REST `$package`, planned syndication.
- (planned) `pro-library-validator` — containerised local FHIR Validator pre-baked with PRO Library packages, lockstep release.

## Strategic context

See in `fhir-sdc-questionnaire-service`:
- [`VISION.md`](../fhir-sdc-questionnaire-service/VISION.md) — overall architecture, authority-gap statement, research questions, roadmap
- [`ARTIFACT_METADATA_POLICY.md`](../fhir-sdc-questionnaire-service/ARTIFACT_METADATA_POLICY.md) — metadata contract, SemVer rules, derivedFrom + Provenance patterns

## License

FHIR encoding © 2026 BIH-CEI, released under CC-BY-4.0. Each instrument carries its own original-instrument copyright in the artefact's `copyright` field.
