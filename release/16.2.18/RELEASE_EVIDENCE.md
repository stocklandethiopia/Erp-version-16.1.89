# ERP 16.2.18 package evidence — 15 November 2026

## Identity
- Canonical repo: aistockland-web/Erp-version-16.1.89; delivery branch delivery/stockland-full-erp-completion-2026-11-11.
- Actual merged source: fe937ea97123a243c410696e4007c48d3332803d; tree f89615a764cc3ce391380bf31b9d75b7b9e55357.
- Manifest source: 83a43bc0543ae45bfa9bdab52bbcd5c07b61aeb4; GitHub confirms the same complete tree.
- Actions run 43640339960; artifact 14130879479; outer SHA-256 848101156d8410d36b0dcd1b29ca630784790785898c37d97589fae3e9aba96a.
- Inner installer: 2,254,041 bytes; SHA-256 30b3f629e8303d0b30981f311f2f4d32499b012f21e1f44c7f237919aafc9916; 125 ZIP entries, 124 manifest file records, one stockland-erp-app root.

## Verified
- Security/runtime PHP 8.3/8.4 — run 43640339921: PASS.
- Codespaces environment — run 43640339909: PASS for the then-current base devcontainer.
- Exact installer/E2E/backup-restore matrix — run 43640339960: PASS on PHP 8.3/8.4 with MariaDB 10.11 and MySQL 8.0.46.
- Fresh 16.2.18 install on MariaDB and MySQL 8: PASS. MariaDB 16.2.13→16.2.18 upgrade: PASS in the stated matrix.
- Local static package audit: checksums, ZIP CRC/path/root, all 124 manifest hashes, 83 PHP lints, 3 JS checks, 5 JSON parses, Bootstrap 5.3.8 checksum and 14 CSS module rebuilds: PASS.

## Boundaries and blockers
- Direct legacy 16.2.13→16.2.18 upgrade on MySQL 8 is blocked by the documented nullable variant_id primary-key condition from that old source. Fresh MySQL 8 install passes. Do not force a destructive workaround.
- PR #134 accessibility/notification changes and PR #135 HR library/company/payroll-rule form are OPEN/unmerged and excluded from this package. PR #135 browser assertion fails because its rule form does not explain both monthly_tax_bands (legacy) and paye_bands (frozen runs); downstream workflow tests/artifact publishing skipped.
- Independent human/code review outstanding; CI does not substitute for it.
- 37 HR lifecycle tables remain Owner/fingerprint gated; 33 HRX keys remain preservation-only.
- 24 SOP resources remain DRAFT_NOT_APPROVED; HR private-vault host key setup has not been proven live.
- Ethiopian statutory payroll/tax/pension values require qualified Owner/legal/finance validation. Synthetic cycles do not prove legal correctness.
- No live WordPress comparison, production backup/restore, production deployment, GitHub Release or Owner release approval was performed.

State: CI_ACCEPTED / PACKAGE_BUILT / INSTALLER_VERIFIED. Not production-certified and not deployed.