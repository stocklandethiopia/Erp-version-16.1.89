# Stockland Ethiopia ERP — workspace launcher and release handoff

This branch is a Codespaces launcher and engineering handoff, not a replacement ERP source tree. It preserves the historical archive on main and opens the exact canonical ERP source in an isolated Codespaces workspace.

## Canonical production application source
- Repository: https://github.com/aistockland-web/Erp-version-16.1.89
- Delivery branch: delivery/stockland-full-erp-completion-2026-11-11
- Merged commit: fe937ea97123a243c410696e4007c48d3332803d
- Full tree: f89615a764cc3ce391380bf31b9d75b7b9e55357
- Installer: 16.2.18
- Exact post-merge Actions run: 43649406224
- Actions artifact: 14134844691
- Outer SHA-256: 561c3e351c255ea59b29db54bf61e8e8e142434a7bcb6463a25b37db2e1e7c5c
- Inner installer SHA-256: 4a6bb09b4f5819873fff7f1417de20494c7d791003faf9a55649458458977021

## Create the Codespace
https://github.com/codespaces/new?repo=stocklandethiopia%2FErp-version-16.1.89&ref=workspace%2Fstockland-final-integration-2026-11-15

The Dev Container verifies and clones the canonical source commit/tree into canonical-source/. It uses local random credentials and synthetic-only MariaDB 10.11 / optional MySQL 8.0.46 WordPress QA. No production site/database is connected.

## Files
- AGENTS.md: Stockland ERP and schema/release guardrails.
- .devcontainer/: launcher environment; clones and checks canonical ERP before preparing it.
- codespaces/: exact post-merge Actions artifact download and WordPress QA verifier.
- release/16.2.18/: exact release evidence.
- workspace/: source baseline and apparel/reference import handoff.
- The full product/apparel-supply-chain architecture/contracts bundle and exact installer are also supplied as the consolidated local ZIP attachment; import it under product/ and release/16.2.18/ when your Codespace session starts.

The 49-key operational schema remains protected. The 37-table HR lifecycle extension remains Owner/fingerprint-gated; 33 HRX keys remain preservation-only. No third-party reference source code is copied.

**Status:** post-merge CI/package accepted; local static audit passed. Not independent-review-complete, Owner production-release-approved, live-certified or deployed. This commit does not create a Codespace instance; the repository owner clicks Create.
