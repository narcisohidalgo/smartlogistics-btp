# SmartLogistics AI Assistant

The AI Assistant is implemented as a SAPUI5 dialog extension inside the Fiori logistics Shipment Object Page. It is not a separate freestyle application in v1.0.

## Runtime flow

1. The user opens the assistant for the current shipment.
2. The UI calls the bound CAP action `askAssistant`.
3. CAP loads the shipment and its incidents.
4. The selected AI mode produces an answer and suggested actions.
5. The dialog maintains conversation history for follow-up questions.
6. Local knowledge answers also display source document/section labels.

## Modes

- `mock` (default): deterministic, reproducible local responses and lexical retrieval.
- `sap`: SAP AI SDK orchestration using the shipment, incidents, weather and conversation history.

Only Operator (or a cumulative higher role) can run the assistant. Automated tests verify that Viewer receives `403` and Operator receives `200`.

Source: [`AssistantActions.js`](../../cap/smartlogistics-extension/app/smartlogistics-fiori/webapp/ext/AssistantActions.js) and [`logistics-assistant.js`](../../cap/smartlogistics-extension/srv/ai/logistics-assistant.js).
