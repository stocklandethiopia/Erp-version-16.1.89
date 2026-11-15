# Stockland Apparel & Lifestyle Supply Chain — workspace handoff

This branch contains the handoff record for the Apparel Supply Chain engineering workspace. It does **not** replace the canonical Stockland ERP source or the production installer.

## Package

The complete local documentation/contracts package is named:

`STOCKLAND_APPAREL_ENTERPRISE_WORKSPACE_2026-11-15.zip`

SHA-256:
`9593071b85d9a7d3a91a908fe0975106df3aa5977efd6b52de26abb649db30d4`

Size: 158,956 bytes.

The package is available in the ChatGPT project Library. The ZIP itself has not been uploaded as a Git blob in this branch; the SHA and package pointer are recorded here so that the exact Library artifact can be checked before import. Do not treat the pointer as proof that the binary asset exists in this repository.

## What the workspace specifies

- Multi-company Apparel & Lifestyle Supply Chain SaaS product objective.
- Optional owned manufacturing; outsourced brands, wholesalers and retailers can operate without factory MES/MRP modules.
- Independent target applications: Apparel Supply Chain, HR & Workforce, and Finance.
- Full garment product lifecycle: design brief, technical flats, pattern drafting, grading, tech packs, samples, BOM, costing, sourcing, demand/MRP, fabric/roll traceability, cutting, sewing/MES/SFC, quality/CAPA, finishing, packing/cartonization, WMS, wholesale/retail/eCommerce, dispatch, returns and traceability.
- Pre-cut AI design/pattern/cutting assistant specification with deterministic geometry/marker validation and human approvals.
- 25 proposed JSON Schema 2020-12 contracts.
- Nine proposed commit groups, acceptance matrix, Codespaces reuse instructions and release evidence plan.

## Source and provenance

- Canonical source repository: `aistockland-web/Erp-version-16.1.89` (read access only for the currently connected GitHub App).
- Previously inspected canonical delivery commit: `fe937ea97123a243c410696e4007c48d3332803d` (PR #133 merged). Verify the current canonical branch before using that SHA as an implementation base; it may have advanced.
- This repository, `stocklandethiopia/Erp-version-16.1.89`, is a separate owner-controlled archive repo. Its original `main` is a four-file upload snapshot at `d665d92b45345d7868907d30f394a7b755d4a7db`; it is **not** a complete mirror of the canonical source tree and does not share the canonical commit ancestry.
- The uploaded 16.2.18 installer `STOCKLAND_ERP_16.2.18_MASTER_WORDPRESS_INSTALLER (8).zip` has SHA-256 `aee5c551bd3367717091de066bfd5f86d8298dda1f6361d7534813d8087cd54e`. Its embedded release manifest did not declare a canonical Git commit. It is a separately identified artifact, not a proven descendant of the 16.1.89 repository commit.
- This branch holds planning/provenance records only. No PHP runtime, CSS, JavaScript, SQL migration or third-party ERP source code is copied here.

## Existing Stockland safety boundary

Preserve the existing 49 operational schema keys, company and location identities, Product Master STYLE/VARIANT/SKU identities, stock ledger, posted Finance and HR history, approvals and audit history. Do not install or run this workspace against the live site. HR and Finance remain separately owned target applications; their current co-loaded implementation is not represented as already extracted.

## Verification status

- The local workspace ZIP and sidecar SHA were verified before this handoff.
- The ZIP CRC, internal file manifest and 25 JSON Schema Draft 2020-12 meta-schema validations passed in the local preparation session.
- WordPress, Codespaces, databases, AI model and CAD tools were not started.
- No production database/site was accessed or changed.
- No certification or production-readiness claim is made.

## Credential security

A classic GitHub personal access token was exposed in a chat message. Revoke that token in GitHub Settings → Developer settings → Personal access tokens → Tokens (classic), then create a new least-privilege credential through GitHub's secure authorization flow if needed. Never commit PATs, OAuth tokens, app secrets or Codespaces credentials to this repository.
