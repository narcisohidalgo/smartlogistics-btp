using LogisticsService as service from '../../srv/logistics-service';

annotate service.Shipments with @(

    UI.HeaderInfo : {
        TypeName       : 'Shipment',
        TypeNamePlural : 'Shipments',
        Title : {
            $Type : 'UI.DataField',
            Value : shipmentNumber
        },
        Description : {
            $Type : 'UI.DataField',
            Value : purchaseOrderId
        }
    },

        UI.Identification : [
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Refresh Weather',
            Action : 'LogisticsService.refreshWeather'
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Mark as Delivered',
            Action : 'LogisticsService.markAsDelivered'
        }
    ],

    UI.SelectionFields : [
        shipmentNumber,
        purchaseOrderId,
        status,
        weatherRisk,
        destinationCity
    ],

    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Shipment',
            Value : shipmentNumber
        },
        {
            $Type : 'UI.DataField',
            Label : 'Purchase Order',
            Value : purchaseOrderId
        },
        {
            $Type : 'UI.DataField',
            Label : 'Carrier',
            Value : carrier
        },
        {
            $Type : 'UI.DataField',
            Label : 'Origin',
            Value : originCity
        },
        {
            $Type : 'UI.DataField',
            Label : 'Destination',
            Value : destinationCity
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status
        },
        {
            $Type : 'UI.DataField',
            Label : 'Weather Risk',
            Value : weatherRisk
        }
    ],

    UI.FieldGroup #General : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Shipment',
                Value : shipmentNumber
            },
            {
                $Type : 'UI.DataField',
                Label : 'Purchase Order',
                Value : purchaseOrderId
            },
            {
                $Type : 'UI.DataField',
                Label : 'Carrier',
                Value : carrier
            },
            {
                $Type : 'UI.DataField',
                Label : 'Tracking Number',
                Value : trackingNumber
            },
            {
                $Type : 'UI.DataField',
                Label : 'Status',
                Value : status
            },
            {
                $Type : 'UI.DataField',
                Label : 'Package Count',
                Value : packageCount
            },
            {
                $Type : 'UI.DataField',
                Label : 'Total Weight',
                Value : totalWeight
            }
        ]
    },

    UI.FieldGroup #Route : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Origin Country',
                Value : originCountry
            },
            {
                $Type : 'UI.DataField',
                Label : 'Origin City',
                Value : originCity
            },
            {
                $Type : 'UI.DataField',
                Label : 'Destination Country',
                Value : destinationCountry
            },
            {
                $Type : 'UI.DataField',
                Label : 'Destination City',
                Value : destinationCity
            },
            {
                $Type : 'UI.DataField',
                Label : 'Planned Departure',
                Value : plannedDeparture
            },
            {
                $Type : 'UI.DataField',
                Label : 'Planned Arrival',
                Value : plannedArrival
            },
            {
                $Type : 'UI.DataField',
                Label : 'Actual Departure',
                Value : actualDeparture
            },
            {
                $Type : 'UI.DataField',
                Label : 'Actual Arrival',
                Value : actualArrival
            }
        ]
    },

    UI.FieldGroup #Weather : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'Weather Risk',
                Value : weatherRisk
            },
            {
                $Type : 'UI.DataField',
                Label : 'Condition',
                Value : weatherSummary
            },
            {
                $Type : 'UI.DataField',
                Label : 'Forecast Date',
                Value : weatherForecastDate
            },
            {
                $Type : 'UI.DataField',
                Label : 'Maximum Temperature',
                Value : weatherTemperatureMax
            },
            {
                $Type : 'UI.DataField',
                Label : 'Minimum Temperature',
                Value : weatherTemperatureMin
            },
            {
                $Type : 'UI.DataField',
                Label : 'Precipitation Probability',
                Value : weatherPrecipitationProbability
            },
            {
                $Type : 'UI.DataField',
                Label : 'Precipitation',
                Value : weatherPrecipitationSum
            },
            {
                $Type : 'UI.DataField',
                Label : 'Maximum Wind Speed',
                Value : weatherWindSpeedMax
            },
            {
                $Type : 'UI.DataField',
                Label : 'Last Weather Check',
                Value : weatherCheckedAt
            }
        ]
    },

    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'General',
            Label  : 'General Information',
            Target : '@UI.FieldGroup#General'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Route',
            Label  : 'Route & Dates',
            Target : '@UI.FieldGroup#Route'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Weather',
            Label  : 'Weather',
            Target : '@UI.FieldGroup#Weather'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Packages',
            Label  : 'Packages',
            Target : 'packages/@UI.LineItem'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Incidents',
            Label  : 'Incidents',
            Target : 'incidents/@UI.LineItem'
        }
    ]
);

annotate service.Packages with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Package',
            Value : packageNumber
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : description
        },
        {
            $Type : 'UI.DataField',
            Label : 'Quantity',
            Value : quantity
        },
        {
            $Type : 'UI.DataField',
            Label : 'Unit',
            Value : unit
        },
        {
            $Type : 'UI.DataField',
            Label : 'Weight',
            Value : weight
        },
        {
            $Type : 'UI.DataField',
            Label : 'Weight Unit',
            Value : weightUnit
        }
    ]
);

annotate service.Incidents with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Incident',
            Value : incidentNumber
        },
        {
            $Type : 'UI.DataField',
            Label : 'Title',
            Value : title
        },
        {
            $Type : 'UI.DataField',
            Label : 'Severity',
            Value : severity
        },
        {
            $Type : 'UI.DataField',
            Label : 'Status',
            Value : status
        },
        {
            $Type : 'UI.DataField',
            Label : 'Reported At',
            Value : reportedAt
        },
        {
            $Type : 'UI.DataField',
            Label : 'Resolved At',
            Value : resolvedAt
        },
        {
            $Type  : 'UI.DataFieldForAction',
            Label  : 'Resolve',
            Action : 'LogisticsService.resolveIncident'
        },

    ]
);

annotate service.Incidents with actions {
    resolveIncident @(
        Common.SideEffects : {
            TargetProperties : [
                in.status,
                in.resolvedAt
            ]
        }
    );
};

annotate service.Shipments with actions {

    markAsDelivered @(
        Common.SideEffects : {
            TargetProperties : [
                in.status,
                in.actualArrival
            ]
        }
    );

    refreshWeather @(
        Common.SideEffects : {
            TargetProperties : [
                in.weatherRisk,
                in.weatherCode,
                in.weatherSummary,
                in.weatherForecastDate,
                in.weatherTemperatureMax,
                in.weatherTemperatureMin,
                in.weatherPrecipitationProbability,
                in.weatherPrecipitationSum,
                in.weatherWindSpeedMax,
                in.weatherCheckedAt
            ]
        }
    );
};