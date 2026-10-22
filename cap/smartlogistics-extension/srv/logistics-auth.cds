using { LogisticsService } from './logistics-service';

annotate LogisticsService with @(
  requires: ['Viewer', 'system-user']
);

annotate LogisticsService.Shipments with @(
  restrict: [
    {
      grant: 'READ',
      to: 'Viewer'
    },
    {
      grant: 'WRITE',
      to: 'Operator'
    },
    {
      grant: 'CREATE',
      to: 'system-user'
    },
    {
      grant: [
        'markAsDelivered',
        'refreshWeather',
        'askAssistant'
      ],
      to: 'Operator'
    }
  ]
);

annotate LogisticsService.Packages with @(
  restrict: [
    {
      grant: 'READ',
      to: 'Viewer'
    },
    {
      grant: 'WRITE',
      to: 'Operator'
    }
  ]
);

annotate LogisticsService.Incidents with @(
  restrict: [
    {
      grant: 'READ',
      to: 'Viewer'
    },
    {
      grant: 'WRITE',
      to: 'Operator'
    },
    {
      grant: [
        'resolveIncident',
        'analyzeIncident'
      ],
      to: 'Operator'
    }
  ]
);
