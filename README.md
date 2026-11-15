# Stockland Ethiopia ERP — engineering workspace

This branch is a workspace launcher and delivery handoff, not a replacement ERP source tree. It preserves the historical archive on main and opens an isolated Codespaces workspace against the canonical cumulative ERP source.

## Source of truth
- Canonical application: https://github.com/aistockland-web/Erp-version-16.1.89
- Delivery branch: delivery/stockland-full-erp-completion-2026-11-11
- Merged commit: fe937ea97123a243c410696e4007c48d3332803d
- Tree SHA: f89615a764cc3ce391380bf31b9d75b7b9e55357
- ERP installer version: 16.2.18
- Exact installer Actions run: 43640339960; artifact 14130879479; SHA-256 30b3f629e8303d0b30981f311f2f4d32499b012f21e1f44c7f237919aafc9916

The installer manifest names PR verification commit 83a43bc0543ae45bfa9bdab52bbcd5c07b61aeb4. Its complete Git tree equals the actual merged commit tree above.

## Click to create the Codespace
https://github.com/codespaces/new?repo=stocklandethiopia%2FErp-version-16.1.89&ref=workspace%2Fstockland-final-integration-2026-11-15

The Dev Container clones the canonical source at the pinned SHA and verifies its tree before opening it. It prepares PHP 8.3, Node 22, Python 3.12, Composer, GitHub CLI, WP-CLI and isolated Compose services (MariaDB 10.11; optional MySQL 8.0.46). No production data or secrets are loaded.

## Release and product resources
- release/16.2.18/RELEASE_EVIDENCE.md records exact package proof, limits and open gates.
- workspace/REFERENCE_PROJECTS.md captures BengalTex, Euro Suits, Production-Quality ERP V2.0, T-VERSE and Thread ERP, plus two supplemental comparisons.
- The full 25-schema apparel workspace and exact installer are in the downloadable consolidated bundle supplied with this session. Import that bundle under product/ and release/16.2.18/ when needed. The design workspace is not a runtime module.

Status: CI-accepted package baseline; not Owner release-approved, live-certified or deployed. This commit does not create a Codespace instance; the repository owner clicks Create.