# Garment ERP reference repositories — pinned research snapshots

No third-party source was imported. These repositories are comparative design references; inspect license, security, dependency provenance and test coverage before code reuse.

| Rank | Repository and pinned commit | Study | Guardrail |
|---|---|---|---|
| 1 | BengalTex ERP — https://github.com/EnamulHaque68/BengalTex-ERP — 2c8fa04c971f667fbfe11abce57660354575134c | Procurement-to-pay, BOM/MRP, job cards, inventory/QC, finance and deployment/UAT runbooks. | Bangladesh tax, payroll, BDT and labour settings do not transfer to Ethiopia. |
| 2 | Euro Suits ERP — https://github.com/ansu9932/euro-suits-erp-full-project — f017b7ffd57e98174b10262390cbef6a982cd183 | Garment stages, styles/orders, materials, samples, costing, role scopes, audit and migrations. | Public snapshot may differ from production deployment; some features need independent acceptance. |
| 3 | Production-Quality ERP V2.0 — https://github.com/ratuldev47782/Production-Quality-ERP-V-2.0 — 8dd6b25d2d6759f5776748fdf664e409476e1c46 | SMV/SAM, hourly target/actual, line capacity, manpower, WIP and defect codes. | Narrow shop-floor tool; review auth, role and tenant controls. |
| 4 | T-VERSE — https://github.com/azad-727/Tverse — e3c245981dc753d90a5a021f26cfe047cf8eb452 | Marketplace SKU aliases, bundles, reservation, pick/pack/dispatch, returns and lot reconciliation. | Not full manufacturing or finance GL; enforce transaction/idempotency controls. |
| 5 | Thread ERP / garment-erp — https://github.com/alidevrunner1012/garment-erp — 6ac233e905bc278dd0a264e7694ec60f241f8597 | Picker assignment, shortage capture, barcode gate, stock deduct and reservation release. | Small order/WMS app, not full ERP. |

Supplemental: ApparelFlow ERP (cutting verification and sewing queue; improve its per-row writes into atomic transactions); mktf-tailoring (checkpointed tailoring orders and measurements; do not adopt risky public-storage/RLS-disable patterns).

## Adoption gate
Pin exact SHA; read LICENSE and dependency manifests; security-review auth/tenant/RLS and secrets; evaluate atomic transactions, concurrency, idempotency and audit; map each behavior to Stockland screens, REST/API, role/location, 49-key schema, ledger, notification, SOP and regression tests. If no license is present, do not copy code. Reimplement accepted patterns inside the existing Stockland architecture; never merge a reference codebase wholesale.
