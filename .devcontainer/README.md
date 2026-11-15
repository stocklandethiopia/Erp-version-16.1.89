# Codespaces — Stockland ERP exact 16.2.18

This holder repository clones the canonical ERP at the pinned merge SHA into canonical-source/. It checks the origin and exact Git tree; modified/non-Git folders are preserved and rejected, never overwritten. The source is mounted at /workspaces/stockland-erp; this workspace is mounted at /workspaces/stockland-workspace.

Default environment: PHP 8.3, Node 22, Python 3.12, Composer, GitHub CLI, Docker Compose and verified WP-CLI. It starts disposable WordPress + MariaDB 10.11 at private port 8080. MySQL 8.0.46 is an optional profile on private port 8082. The 16.2.18-only release guard skips historical 16.2.13/16.2.15 intake, repair and activation.

Create a Codespace:
https://github.com/codespaces/new?repo=stocklandethiopia%2FErp-version-16.1.89&ref=workspace%2Fstockland-final-integration-2026-11-15

Then authenticate gh with Actions read access to the canonical repository and run:
bash /workspaces/stockland-workspace/codespaces/verify-exact-16.2.18.sh all

That helper downloads Actions artifact 14130879479 from run 43640339960, verifies outer and inner SHA-256, manifest inventory and commit/tree parity, then installs only on the Compose disposable database. It verifies WordPress DB_NAME/DB_HOST before reset. Never run against live Stockland.

The requested 2-core / 8-GB / 32-GB machine is subject to account availability/quota; keep forwarded ports private. The Codespace is created only after the repository owner clicks Create.
