# Stockland ERP engineering rules

- Continue the existing cumulative Stockland Ethiopia WordPress ERP/PWA. Do not rebuild, downgrade, replace or overlay unrelated plugin archives.
- Canonical source: aistockland-web/Erp-version-16.1.89; branch delivery/stockland-full-erp-completion-2026-11-11; merge fe937ea97123a243c410696e4007c48d3332803d; tree f89615a764cc3ce391380bf31b9d75b7b9e55357.
- Preserve the 49 operational keys (29 Core/Operations + 16 Finance/Procurement + 4 legacy HR/Payroll). Keep the 37 HR lifecycle tables separately Owner/fingerprint-gated; 33 HRX keys are preservation-only. Never auto-create or mutate these schemas.
- Preserve product/style/variant identity, SKU master, branch/warehouse IDs, stock ledger, reservations, inventory history, posted journals, payroll history and audit chain.
- Use synthetic test data only. Never connect this workspace to the live WordPress site or production DB.
- Recheck authorization on the server for every write, role, branch/location and workflow state; enforce transactions, idempotency, maker-checker, audit trail and rollback.
- Statutory payroll/tax/pension remains fail-closed pending qualified Ethiopian legal/finance validation.
- Do not import third-party source code until exact license, security and provenance are reviewed. Study the five primary reference repositories comparatively only.
- Owner approval remains required for live deployment/DB writes, schema-governance changes, statutory rules, historical journal/payroll corrections, secrets, DNS/hosting/billing, irreversible deletion and deployment-capable merge/release.
- Never commit or disclose PATs, API keys, Codex auth or secrets. Use GitHub secure sign-in; this repository contains no credentials.
- Report PASS/FAIL/BLOCKED/NOT RUN separately. CI is not independent code review and is not live certification.