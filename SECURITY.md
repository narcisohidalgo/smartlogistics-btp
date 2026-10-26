# Security

## Reporting

Do not publish real credentials, tokens, service keys or exploitable account details in a public issue. Use a private communication channel with the repository owner for sensitive reports.

## Repository rules

- Never commit `.env` files, service keys, private certificates or access tokens.
- Use environment variables, SAP BTP bindings, destinations and Integration Suite security material.
- Use synthetic portfolio data only.
- Sanitize screenshots, logs, Postman environments and exported integration artifacts.
- Grant only the scopes and roles required by each business persona.

## Dependency audit

CI runs `npm audit --omit=dev` as an informational production-dependency check.

The directly fixable `body-parser` advisory is addressed by the committed lockfile. The remaining production audit finding is the `node-forge` advisory inherited transitively through `jks-js`, SAP Cloud SDK connectivity and the SAP AI SDK dependency chain. The upstream advisory currently provides no patched `node-forge` release.

The repository intentionally does not use `npm audit fix --force` because npm proposes a breaking SAP AI SDK change rather than a safe patched dependency chain. This dependency should be updated when the upstream SAP/Node dependency chain exposes a patched version.

## Public ABAP source

The ADT/abapGit source published in `abap/smartlogistics-core/src/` is a sanitized portfolio snapshot. The OAuth token URL, integration endpoint, client ID and client secret from the original export were replaced with non-operational sample values in `ZCL_SL_INTEGRATION_CLIENT`. A generated communication-target key was replaced with `0` in `ZSL_INT_TARGET`. **Neither file is ready for production integration as-is.** Re-create the generated communication target and configure approved authentication with SAP Communication Management/secure destinations. Do not replace placeholders by committing real credentials to this repository.


## Integration Suite portfolio export

`integration/iflows/ABAP_PO_to_CAP_Shipment_sanitized.zip` is a copy of the individual exported Cloud Integration flow, not a tenant package or live environment backup. Its hardcoded CAP receiver URL and OAuth2 credential alias were replaced with deliberately nonfunctional placeholders. Only the ZIP sanitized for publication must be used for portfolio sharing. Restore these references securely within the SAP Cloud Integration UI in your own tenant before deploying; do not push configuration with secrets or internal endpoints to this public repository. The deployed flow was not modified as part of publication.
