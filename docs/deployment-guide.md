# SmartLogistics BTP — Reproduction and deployment guide

This guide connects the public **ABAP Cloud**, **CAP/Fiori** and **Cloud Integration** sources. It describes the delivered architecture and the steps needed to reproduce it in your own SAP landscape. **It is not a one-command installation or a verified clean-room deployment.**

## 1. Repository and prerequisites

Clone the complete source:

```bash
git clone https://github.com/narcisohidalgo/smartlogistics-btp.git
cd smartlogistics-btp
```

For a **local CAP demonstration**, use Node.js 24, npm and an internet connection for dependency installation. Local CAP tests use SQLite, deterministic AI responses and development-only mock identities; they do not require a live BTP tenant.

For the **SAP BTP end-to-end deployment**, prepare and configure the necessary entitlements and accounts:

- SAP BTP subaccount and Cloud Foundry org/space with deployment permission.
- SAP BTP ABAP Environment, Eclipse ABAP Development Tools (ADT) and abapGit integration.
- SAP HANA Cloud/HDI, XSUAA, Destination service, HTML5 Application Repository and SAP Build Work Zone standard.
- SAP Integration Suite / Cloud Integration, with an authorized integration runtime and technical authentication.
- Cloud Foundry CLI with MultiApps deployment support, SAP Business Application Studio or equivalent tooling, and MTA build tools.

The original implementation used SAP BTP trial services. Tenant-specific quotas and service plans can differ.

## 2. CAP — reproduce locally and test

```bash
cd cap/smartlogistics-extension
npm ci
npm test
npm start
```

The default CAP endpoint is **http://localhost:4004/logistics/**. The application includes CSV fixture data, an SQLite development adapter and mock users in `package.json`:

- `viewer` — reads logistics data.
- `operator` — reads/writes data and executes operational/AI actions.
- `supervisor` — cumulative Viewer and Operator scopes.

These are **local demo credentials only**. Do not use them as real SAP BTP identities.

To run the Fiori Logistics development experience, stop/restart the server as appropriate and use:

```bash
npm run watch-smartlogistics-fiori
```

See [CAP documentation](../cap/smartlogistics-extension/README.md) and [manual HTTP examples](../cap/smartlogistics-extension/test.http).

## 3. ABAP Cloud — import into Eclipse ADT

1. Provision a compatible **SAP BTP ABAP Environment** and sign in via Eclipse ADT.
2. Create or select an appropriate ABAP package and transport request as required by your landscape. The original package was `ZSMARTLOGISTICS`.
3. Import/clone this repository using ADT abapGit. The root [`.abapgit.xml`](../.abapgit.xml) specifies `/abap/smartlogistics-core/src/` as the source folder.
4. If your version of abapGit cannot import from a nested starting folder, create a separate abapGit-compatible repository rooted at the exported `src/` objects rather than treating CAP files as ABAP objects.
5. Activate objects in the required dependency order, review service bindings and roles, then initialize synthetic sample data and the PO numbering setup as needed.

The export includes tables, CDS view entities, metadata extensions, managed RAP behavior/draft, supporting classes, service definition/binding and communication artifacts.

**Security:** `ZCL_SL_INTEGRATION_CLIENT` intentionally contains non-working OAuth/endpoint placeholders and `ZSL_INT_TARGET` contains an invalidated generated technical key. Reconfigure communication securely through your own SAP arrangements/destinations; never commit credentials.

See [ABAP import details](../abap/smartlogistics-core/README.md). A fresh import and activation in a second tenant have **not yet been independently verified**.

## 4. CAP — deploy to SAP BTP

Configure the target Cloud Foundry org/space, required service entitlements and deployment permissions. The [`mta.yaml`](../cap/smartlogistics-extension/mta.yaml) defines the Node.js CAP service, HDI deployment, XSUAA, Destination service, HTML5 app-host and Fiori app module.

From `cap/smartlogistics-extension/`:

```bash
npm ci
npm run build
npm run deploy
```

These commands require an authenticated and correctly targeted Cloud Foundry CLI with the relevant deployment plugin. Review the generated MTA deployment changes before proceeding, particularly if reusing an existing subaccount.

Assign the appropriate XSUAA role collections to business users and ensure that Work Zone and your application destinations forward authentication to the CAP backend. Business roles are Viewer, Operator and Supervisor; the integration-facing technical identity is limited to the necessary shipment creation permission.

**AI:** local mode is reproducible without cloud credentials. `SMARTLOGISTICS_AI_MODE=sap` requires SAP AI services and an appropriate service binding. The documented SAP Document Grounding trial validation is a separate experiment, not a promise of automatic cloud grounding after deployment.

## 5. Integration Suite — import the sanitized iFlow

Import [`ABAP_PO_to_CAP_Shipment_sanitized.zip`](../integration/iflows/ABAP_PO_to_CAP_Shipment_sanitized.zip) into **SAP Cloud Integration**.

Before deploying:

1. Update the CAP receiver address (the ZIP intentionally uses `https://example.invalid/logistics/Shipments`).
2. Create and assign your own secure **OAuth2 Client Credentials** material; replace the non-operational alias `PORTFOLIO_REPLACE_WITH_OAUTH2_ALIAS`.
3. Configure the HTTPS sender endpoint and the appropriate authorization/technical identity for the ABAP request (including `ESBMessaging.send` as relevant).
4. Verify that the technical caller can **create Shipments** but has no unnecessary interactive permissions.
5. Deploy and test with a synthetic purchase-order payload, checking message processing and the resulting shipment.

The included [Groovy mapping](../integration/iflows/abap-po-to-cap-shipment/MapPurchaseOrder.groovy) maps purchase-order references and planned dates to the CAP shipment payload. Some carrier/route/tracking fields intentionally use demonstration values.

This sanitized ZIP passed integrity/XML checks, but its import and deployment into a fresh tenant have **not** been tested. The original working tenant flow was not modified to create the published copy.

## 6. User experience and end-to-end check

Configure SAP Build Work Zone (standard), add the HTML5 Fiori Logistics application to the site and assign user role collections. Fiori Orders is generated from the RAP OData V4 service and annotations; a separate stand-alone UI5 source for Fiori Orders is not included.

Suggested smoke test in a configured environment:

1. Open Fiori Orders and create/activate a draft purchase order.
2. Execute **Send to Logistics**.
3. Check the successful Cloud Integration message.
4. Open Fiori Logistics and confirm one matching shipment exists.
5. Refresh weather using Open-Meteo, inspect risk fields and test incident operations.
6. Check Viewer/Operator authorization behavior; run the local CAP regression suite separately.

See [End-to-End Demo](end-to-end-demo.md), [architecture](architecture/solution-architecture.md) and [evidence screenshots](screenshots/README.md).

## 7. Security and reproducibility boundaries

Do **not** publish or reuse tenant service keys, OAuth secrets, access tokens, `.env` files, real user data or generated deployment archives. The repository contains sanitized example values, not a working production configuration.

The production dependency audit is informative rather than blocking; see [SECURITY.md](../SECURITY.md) for the documented upstream `node-forge` advisory. The project is a **portfolio demonstration**, not a production-certified system. Tests do not validate ABAP activation, Groovy runtime deployment, UI OPA journeys or full SAP BTP provisioning.

**Completion criterion for a fresh environment:** successful ADT activation, BTP deployment, integration authentication, Fiori navigation and the end-to-end smoke test above. Until then, treat this guide as a supported architecture walkthrough, not a completed clean-room reproduction.
