# GitHub workspace branch — 15 November 2026

A dedicated workspace branch has been committed in the writable Stockland repository. It is a launcher and handoff surface, not the canonical ERP application source.

- Workspace repository: https://github.com/stocklandethiopia/Erp-version-16.1.89
- Branch: `workspace/stockland-final-integration-2026-11-15`
- Codespaces creation: https://github.com/codespaces/new?repo=stocklandethiopia%2FErp-version-16.1.89&ref=workspace%2Fstockland-final-integration-2026-11-15
- Post-create setup commit: `690e7b8fd4567b01ee191a936fc74f73470d15d9`

The launcher clones canonical application source into `canonical-source/` and verifies the exact merged commit/tree recorded in `SOURCE_BASELINE.json`. It uses synthetic isolated databases. The connected GitHub identity can write to the launcher repo but has `push=false` on canonical `aistockland-web/Erp-version-16.1.89`; canonical pushes require owner-side write permission or the authorized canonical account connection.

## Included in remote launcher branch

Root `AGENTS.md` and `README.md`; `.devcontainer/` wrapper; exact artifact SHA/tree verifier in `codespaces/`; 16.2.18 release evidence; source baseline and launcher handoff; and a branch CI workflow. The full Apparel product folder (25 JSON Schemas and architecture package) is in the consolidated local bundle and has not yet been pushed into this repository.

## Owner action

Create the Codespace using the link above. The account quota/machine confirmation and final Create click are owner-side. No Codespace has been created. The launcher workflow has not yet produced an observed Actions run.
