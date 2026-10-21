using { smartlogistics as db } from '../db/schema';

service LogisticsService @(path: '/logistics') {

  type IncidentAnalysis {
    summary            : LargeString;
    probableCause      : LargeString;
    operationalImpact  : LargeString;
    priority           : db.IncidentSeverity;
    recommendedActions : many String(500);
  }

  type AssistantResponse {
    answer             : LargeString;
    suggestedActions   : many String(500);
    sources            : many String(500);
  }

  entity Shipments as projection on db.Shipments {
    *,
    virtual totalWeight  : Decimal(13,3),
    virtual packageCount : Integer
  }
  actions {
    action markAsDelivered() returns Shipments;
    action refreshWeather() returns Shipments;
    action askAssistant(
      message : LargeString,
      history : LargeString
    ) returns AssistantResponse;
  };

  entity Packages as projection on db.Packages;

  entity Incidents as projection on db.Incidents
  actions {
    action resolveIncident() returns Incidents;
    action analyzeIncident() returns IncidentAnalysis;
  };
}