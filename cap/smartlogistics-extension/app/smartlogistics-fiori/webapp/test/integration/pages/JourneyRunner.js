sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"smartlogistics/smartlogisticsfiori/test/integration/pages/ShipmentsList.gen",
	"smartlogistics/smartlogisticsfiori/test/integration/pages/ShipmentsObjectPage.gen"
], function (JourneyRunner, ShipmentsListGenerated, ShipmentsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('smartlogistics/smartlogisticsfiori') + '/test/flp.html#app-preview',
        pages: {
			onTheShipmentsListGenerated: ShipmentsListGenerated,
			onTheShipmentsObjectPageGenerated: ShipmentsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

