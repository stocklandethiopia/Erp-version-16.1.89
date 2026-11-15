# Stockland ERP 16.2.18 — exact post-merge release evidence

- Canonical source: aistockland-web/Erp-version-16.1.89
- Branch: delivery/stockland-full-erp-completion-2026-11-11
- Commit: fe937ea97123a243c410696e4007c48d3332803d
- Tree: f89615a764cc3ce391380bf31b9d75b7b9e55357
- GitHub Actions run: 43649406224
- One-pack artifact: 14134844691; outer bytes 2,249,086; SHA-256 561c3e351c255ea59b29db54bf61e8e8e142434a7bcb6463a25b37db2e1e7c5c
- Inner installer: 2,254,042 bytes; SHA-256 4a6bb09b4f5819873fff7f1417de20494c7d791003faf9a55649458458977021
- Embedded source commit is the actual merged commit; ZIP one-root, CRC and 124 per-file manifest checks pass.

Post-merge workflow jobs PASS: MariaDB 10.11/PHP 8.3, MariaDB 10.11/PHP 8.4, MySQL 8.0.46/PHP 8.3, MySQL 8.0.46/PHP 8.4, Windows branch-folder agent contracts and one-pack publication. Codespaces environment validation run 43649406250 PASS. Security/runtime PHP 8.3/8.4 run 43640339921 passed on the PR source tree, whose Git tree equals the final merge tree.

Limitations:
- Direct MySQL 8 upgrade from the historical 16.2.13 package remains blocked by the documented nullable variant_id primary-key defect; fresh MySQL 8 install passes.
- PR #134 remains OPEN/unmerged and excluded. PR #135 remains OPEN/unmerged and failed the exact-head browser acceptance phrase for both monthly_tax_bands (legacy) and paye_bands (frozen runs); downstream business/backup/artifact gates were skipped.
- Independent human/code review is outstanding.
- 49 operational keys preserved; 37 HR lifecycle extension tables gated by Owner/fingerprint; 33 HRX keys preservation-only.
- 24 SOP resources remain DRAFT_NOT_APPROVED; live HR vault host-key setup untested.
- Ethiopian statutory payroll/tax/pension values remain subject to qualified Owner/legal/finance approval.
- No live site/database, deployment, GitHub Release or Owner production sign-off occurred.

The consolidated local package contains tools/audit_local_release.py. Local package/static checks passed; local WordPress E2E is NOT RUN because Docker is unavailable in the current local container. This is not a claim of live certification.
