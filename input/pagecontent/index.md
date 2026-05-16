# PRO Library 0.1.0

A curated reference source of FHIR-encoded Patient-Reported Outcome Measure (PROM) Questionnaires.

## Status

**Pre-stable (0.x line).** Expect breaking changes. Namespace is provisional under BIH-CEI stewardship — see the repository README for the migration plan if normative authority moves to a different entity.

This is the first end-to-end demonstration release. Scope: **PHQ-9 only**. The intent is to prove the pipeline (FSH → SUSHI → IG Publisher → release tarball → consumer integration), not to ship comprehensive content.

## What's in this release

| Resource | Canonical | Version | Notes |
|---|---|---|---|
| `Questionnaire/phq-9` | https://fhir.bih-charite.de/pro-library/Questionnaire/phq-9 | 0.1.0 | derivedFrom MII PRO `mii-qst-pro-phq-9\|2026.3.0` |
| `Library/release-0-1-0` | https://fhir.bih-charite.de/pro-library/Library/release-0-1-0 | 0.1.0 | CRMI asset-collection manifest |
| `Provenance` for PHQ-9 | (server-assigned id) | n/a | Records derivation source + bibliographic anchor |

Plus one should-pass test `QuestionnaireResponse` shipped in `input/data/`.

## How to consume

Once the release tarball is published (see release workflow), consumers can either:

1. **Pull as a FHIR Package** — `npm install bih-cei.fhir.pro-library@0.1.0` from the npm-style registry (or use the tarball URL directly).
2. **Pull via the Form Manager runtime** — the companion [`fhir-sdc-questionnaire-service`](https://github.com/BIH-CEI/fhir-sdc-questionnaire-service) container loads this PRO Library alongside MII PRO at boot, then serves it via REST `$package`.
3. **Pull via CRMI manifest** — once `$crmi-package?manifest=https://fhir.bih-charite.de/pro-library/Library/release-0-1-0` is wired up.

## Strategic context

See in the companion form-manager repository:
- `VISION.md` — overall architecture and authority-gap statement
- `ARTIFACT_METADATA_POLICY.md` — metadata contract this release follows

## License

FHIR encoding © 2026 BIH-CEI, released under CC-BY-4.0. The PHQ-9 itself is © Kroenke, Spitzer & Williams (2001) and is freely available for clinical and research use with attribution.
