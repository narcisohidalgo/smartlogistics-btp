# AI Prompts and Structured Outputs

The versioned orchestration configurations are stored with the CAP application in [`cap/smartlogistics-extension/ai`](../../cap/smartlogistics-extension/ai/).

## Implemented prompts

| Configuration | Purpose | Output |
|---|---|---|
| `smartlogistics-incident-analyzer-orchestration.json` | Analyze one incident with shipment/weather context | Summary, probable cause, impact, priority and recommended actions |
| `smartlogistics-assistant-orchestration.json` | Answer questions about one shipment | Answer and suggested actions |
| `smartlogistics-grounded-orchestration.json` | Record the SAP Document Grounding Basic Trial experiment | Grounded response from the configured trial repository |

The Node.js handlers validate structured responses before returning them to CAP. Prompts instruct the model to use only the supplied business context and to state when information is insufficient.

## Reproducibility and security

Cloud AI is opt-in through `SMARTLOGISTICS_AI_MODE=sap`. Service bindings, service keys and tokens are supplied at runtime and are not stored in Git. Default local/test mode is deterministic and does not claim to reproduce model output.
