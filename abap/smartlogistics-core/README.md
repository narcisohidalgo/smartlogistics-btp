# SmartLogistics ABAP Cloud / RAP — Eclipse ADT sources

This folder contains the ABAP Cloud objects exported from the `ZSMARTLOGISTICS` package in Eclipse ABAP Development Tools (ADT) in **abapGit serialization format**. They complement the CAP and SAPUI5 sources in the same public repository.

## Included source

- Database tables for suppliers, products, purchase-order header/items and RAP draft persistence (`ZSL_*`).
- Interface and projection CDS view entities (`ZI_SL_*`, `ZC_SL_*`) and UI metadata extensions.
- Managed RAP behaviors with draft, validations, determinations, composed items and the `sendToLogistics` action (`ZBP_I_SL_PURCHASEORDER`).
- Supporting ABAP classes, including sample data, number-range initialization and Integration Suite connectivity.
- Service definition, OData V4 service binding, number-range/data-element/domain, communication and UI registration metadata.

## Clone and import into ABAP Environment

1. Clone `https://github.com/narcisohidalgo/smartlogistics-btp.git` to inspect both ABAP and CAP code.
2. To import ABAP, prepare an **SAP BTP ABAP Environment** and Eclipse **ABAP Development Tools** with the abapGit Repositories integration. Create/select an appropriate ABAP development package (the original root package was `ZSMARTLOGISTICS`) and transport request as required.
3. In Eclipse ADT, open **abapGit Repositories**, choose the clone/import action, provide the repository URL, select the `main` branch and your target package.
4. The root `.abapgit.xml` specifies `STARTING_FOLDER=/abap/smartlogistics-core/src/` with folder logic `FULL`, so only the serialized ABAP objects in this subtree are intended for import. If your ADT/abapGit version cannot import from this nested folder, use an abapGit-compatible root-only export of this folder rather than importing the CAP modules as ABAP objects.
5. Activate the supported development objects in the target system, configure service binding/authorizations and initialize test/master data as appropriate. Actual import/activation in a separate environment is **not** verified by GitHub Actions.

## Redacted integration settings — important

The public snapshot deliberately does **not** expose the original OAuth client credentials or tenant endpoints.

- `src/zcl_sl_integration_client.clas.abap`: `lc_token_url` and `lc_iflow_url` point to non-working `example.invalid` domains, while `lc_client_id` and `lc_client_secret` contain descriptive non-secret placeholders.
- `src/zsl_int_target.clas.abap`: the generated technical `SECKEY` value is replaced with `0`. Recreate/regenerate the target in the destination SAP system; this placeholder is not a functioning generated key.
- Configure real endpoints and OAuth securely via SAP Communication Management / communication arrangements or a secure destination. **Never put live credentials into Git or substitute real values into these public source files.** The integration method is preserved as a portfolio code example; its credential-loading approach must be adapted for production.
- The published Integration Suite iFlow named **ABAP PO to CAP Shipment** is documented in `integration/iflows/` has a **sanitized** iFlow export in [`integration/iflows/`](../../integration/iflows/). The target tenant still requires its own OAuth2 credentials, receiver URL and related security configuration.

## Reproducibility boundaries

This repository lets recruiters clone and inspect the ABAP/RAP and CAP/Fiori *sources in one place*. It does not represent a one-command deployment: SAP BTP services, tenant-specific communication arrangements, role assignments, integration artifacts and credentials are not distributed. The generated Fiori Orders application was demonstrated through the RAP OData V4 service binding; it is not shipped as a separate UI5 module.

## Evidence

- [Purchase Orders List Report](../../docs/screenshots/abap-rap/abap-rap-purchase-orders-list.png)
- [Purchase Order Object Page](../../docs/screenshots/abap-rap/abap-rap-purchase-order-object-page.png)
- [Published OData V4 service binding](../../docs/screenshots/abap-rap/abap-rap-odata-v4-service-binding.png)

Custom procurement DCL and instance authorization enforcement are not claimed for this release; RAP authorization extension points exist, but custom enforcement is not implemented.
