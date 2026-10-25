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
