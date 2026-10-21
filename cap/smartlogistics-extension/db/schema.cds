namespace smartlogistics;

using { cuid, managed } from '@sap/cds/common';

type ShipmentStatus : String enum {
  PLANNED;
  IN_TRANSIT;
  DELIVERED;
  DELAYED;
  CANCELLED;
}

type IncidentStatus : String enum {
  OPEN;
  IN_PROGRESS;
  RESOLVED;
  CLOSED;
}

type IncidentSeverity : String enum {
  LOW;
  MEDIUM;
  HIGH;
  CRITICAL;
}

type WeatherRisk : String(10) enum {
  UNKNOWN;
  LOW;
  MEDIUM;
  HIGH;
}

entity Shipments : cuid, managed {
  shipmentNumber     : String(20);
  purchaseOrderId    : String(20);
  carrier            : String(80);
  trackingNumber     : String(60);

  originCountry      : String(3);
  originCity         : String(60);

  destinationCountry : String(3);
  destinationCity    : String(60);

  plannedDeparture   : DateTime;
  plannedArrival     : DateTime;
  actualDeparture    : DateTime;
  actualArrival      : DateTime;

  status             : ShipmentStatus default 'PLANNED';

  weatherRisk                     : WeatherRisk default 'UNKNOWN';
  weatherCode                     : Integer;
  weatherSummary                  : String(80);
  weatherForecastDate             : Date;

  weatherTemperatureMax           : Decimal(5,2);
  weatherTemperatureMin           : Decimal(5,2);

  weatherPrecipitationProbability : Integer;
  weatherPrecipitationSum         : Decimal(7,2);
  weatherWindSpeedMax             : Decimal(7,2);

  weatherCheckedAt                : DateTime;

  packages           : Composition of many Packages
                         on packages.shipment = $self;

  incidents          : Composition of many Incidents
                         on incidents.shipment = $self;
}

entity Packages : cuid, managed {
  shipment           : Association to Shipments;

  packageNumber      : String(20);
  description        : String(120);

  quantity           : Decimal(13,3);
  unit               : String(3);

  weight             : Decimal(13,3);
  weightUnit         : String(3);

  length             : Decimal(13,2);
  width              : Decimal(13,2);
  height             : Decimal(13,2);
  dimensionUnit      : String(3);
}

entity Incidents : cuid, managed {
  shipment           : Association to Shipments;

  incidentNumber     : String(20);
  title              : String(100);
  description        : LargeString;

  severity           : IncidentSeverity default 'MEDIUM';
  status             : IncidentStatus default 'OPEN';

  reportedAt         : DateTime;
  resolvedAt         : DateTime;
}