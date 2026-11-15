# Stockland ERP — one-click Codespaces workspace

Click to create the workspace from this branch:
https://github.com/codespaces/new?repo=stocklandethiopia%2FErp-version-16.1.89&ref=workspace%2Fstockland-final-integration-2026-11-15

## Source pin
- Canonical repository: aistockland-web/Erp-version-16.1.89
- Delivery branch: delivery/stockland-full-erp-completion-2026-11-11
- Commit: fe937ea97123a243c410696e4007c48d3332803d
- Tree: f89615a764cc3ce391380bf31b9d75b7b9e55357

The host initializer clones the canonical repo to canonical-source/, checks the origin and exact tree, and refuses to overwrite an unknown or modified clone. The canonical source remains the application; this repository is the launcher.

## Environment
PHP 8.3, Node 22, Python 3.12, Composer, GitHub CLI, Docker-outside-of-Docker, checksum-verified WP-CLI, MariaDB 10.11, optional MySQL 8.0.46 and private QA ports 8080/8082. Local credentials are random and ignored by Git. The startup guard selects only 16.2.18 and skips legacy .13/.15 intake.

After GitHub CLI sign-in, run:
bash /workspaces/stockland-workspace/codespaces/verify-exact-16.2.18.sh all

It downloads original Actions artifact 14134844691 from run 43649406224, verifies outer SHA-256 561c3e351c255ea59b29db54bf61e8e8e142434a7bcb6463a25b37db2e1e7c5c, verifies inner installer SHA-256 4a6bb09b4f5819873fff7f1417de20494c7d791003faf9a55649458458977021 and its sidecar, validates manifest source commit/tree plus 124 file hashes, then installs only in disposable WordPress databases. It checks database host/name before any reset.

The connected GitHub account has admin/push access on this launcher repository but only read access on canonical aistockland-web/Erp-version-16.1.89. Canonical source pushes require the owner to grant write access or reconnect under the authorized canonical owner account. Never paste a PAT into chat.
