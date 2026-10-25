# Grounding and Retrieval

SmartLogistics contains two deliberately separate grounding tracks.

## 1. SAP Document Grounding trial

SAP Document Grounding was tested with SAP Generative AI Hub Basic Trial using a vector data repository and an orchestration configuration. This proves hands-on use of the SAP-managed capability, but the time-limited trial path is not the default reproducible application runtime.

The repository keeps [`smartlogistics-grounded-orchestration.json`](../../cap/smartlogistics-extension/ai/smartlogistics-grounded-orchestration.json) as sanitized configuration evidence. The original Basic Trial data-repository identifier is replaced with the `<DOCUMENT_REPOSITORY_ID>` placeholder. No service key, token or client secret is committed.

## 2. Local reproducible retriever

The runnable local assistant uses [`knowledge-retriever.js`](../../cap/smartlogistics-extension/srv/ai/knowledge-retriever.js). It:

- loads project-owned Markdown documents;
- splits them by headings;
- normalizes tokens and a small synonym list;
- applies deterministic lexical weights;
- returns the highest-scoring sections with source labels.

This implementation is **lexical retrieval**. It uses no embeddings, vector index or SAP Document Grounding service and must not be described as vector RAG.

## Knowledge base

- [`temperature-alert-procedure.md`](../../cap/smartlogistics-extension/ai/knowledge/temperature-alert-procedure.md)
- [`shipment-delay-escalation-policy.md`](../../cap/smartlogistics-extension/ai/knowledge/shipment-delay-escalation-policy.md)
- [`weather-risk-route-response.md`](../../cap/smartlogistics-extension/ai/knowledge/weather-risk-route-response.md)

The automated suite verifies that a temperature-guidance question returns at least one source reference. This validates the local retriever, not the SAP Document Grounding service.
