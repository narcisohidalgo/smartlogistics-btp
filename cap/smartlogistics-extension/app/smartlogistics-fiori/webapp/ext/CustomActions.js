sap.ui.define([
  "sap/m/MessageBox"
], function (MessageBox) {
  "use strict";

  return {

    enabledForSingleSelection: function (oContext, aSelectedContexts) {
      return Array.isArray(aSelectedContexts) &&
        aSelectedContexts.length === 1;
    },

    analyzeIncident: async function (oContext, aSelectedContexts) {

      if (!aSelectedContexts || aSelectedContexts.length !== 1) {
        MessageBox.warning(
          "Please select exactly one incident."
        );
        return;
      }

      const oIncidentContext = aSelectedContexts[0];
      const oModel = oIncidentContext.getModel();

      const oAction = oModel.bindContext(
        "LogisticsService.analyzeIncident(...)",
        oIncidentContext
      );

      try {

        await oAction.execute();

        const oAnalysis =
          oAction.getBoundContext().getObject();

        const aActions =
          Array.isArray(oAnalysis.recommendedActions)
            ? oAnalysis.recommendedActions
            : [];

        const sMessage = [
          "Summary",
          oAnalysis.summary || "-",
          "",
          "Probable Cause",
          oAnalysis.probableCause || "-",
          "",
          "Operational Impact",
          oAnalysis.operationalImpact || "-",
          "",
          `Priority: ${oAnalysis.priority || "-"}`,
          "",
          "Recommended Actions",
          ...aActions.map(
            (sAction, iIndex) =>
              `${iIndex + 1}. ${sAction}`
          )
        ].join("\n");

        MessageBox.information(
          sMessage,
          {
            title: "AI Incident Analysis"
          }
        );

      }
      catch (oError) {

        console.error(
          "Analyze Incident failed:",
          oError
        );

        MessageBox.error(
          oError?.message ||
          "AI Incident Analyzer failed"
        );
      }
    }
  };
});
