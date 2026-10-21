sap.ui.define([
  "sap/m/Dialog",
  "sap/m/VBox",
  "sap/m/Text",
  "sap/m/TextArea",
  "sap/m/Button",
  "sap/m/MessageBox"
], function (
  Dialog,
  VBox,
  Text,
  TextArea,
  Button,
  MessageBox
) {
  "use strict";

  function addMessage(oHistory, sRole, sMessage) {
    oHistory.addItem(
      new VBox({
        items: [
          new Text({
            text: sRole,
            wrapping: true
          }).addStyleClass("sapUiTinyMarginBottom"),
          new Text({
            text: sMessage,
            wrapping: true
          })
        ]
      }).addStyleClass("sapUiSmallMarginBottom")
    );
  }

  function formatResponse(oResponse) {

    const aSuggestedActions =
      Array.isArray(oResponse.suggestedActions)
        ? oResponse.suggestedActions
        : [];

    const aSources =
      Array.isArray(oResponse.sources)
        ? oResponse.sources
        : [];

    let sText =
      oResponse.answer || "No answer returned.";

    if (aSuggestedActions.length > 0) {
      sText +=
        "\n\nSuggested actions:\n" +
        aSuggestedActions
          .map(
            (sAction, iIndex) =>
              `${iIndex + 1}. ${sAction}`
          )
          .join("\n");
    }

    if (aSources.length > 0) {
      sText +=
        "\n\nSources:\n" +
        aSources
          .map(
            sSource =>
              `• ${sSource}`
          )
          .join("\n");
    }

    return sText;
  }

  return {

    openAssistant: function (oContext) {

      if (
        !oContext ||
        typeof oContext.getModel !== "function"
      ) {
        MessageBox.error(
          "Shipment context is not available."
        );
        return;
      }

      const oModel = oContext.getModel();

      const aConversationHistory = [];

      const oHistory = new VBox({
        width: "100%"
      });

      const oQuestion = new TextArea({
        width: "100%",
        rows: 3,
        placeholder:
          "Ask something about this shipment..."
      });

      const oSendButton = new Button({
        text: "Send",
        type: "Emphasized"
      });

      const oDialog = new Dialog({
        title: "SmartLogistics AI Assistant",
        contentWidth: "42rem",
        stretchOnPhone: true,
        horizontalScrolling: false,
        verticalScrolling: true,
        content: [
          new VBox({
            items: [
              new Text({
                text:
                  "Ask questions about the current shipment, " +
                  "its incidents, status and weather risk.",
                wrapping: true
              }).addStyleClass("sapUiSmallMarginBottom"),

              oHistory,

              oQuestion,

              oSendButton
            ]
          }).addStyleClass("sapUiMediumMargin")
        ],
        endButton: new Button({
          text: "Close",
          press: function () {
            oDialog.close();
          }
        }),
        afterClose: function () {
          oDialog.destroy();
        }
      });

      oSendButton.attachPress(async function () {

        const sMessage =
          oQuestion.getValue().trim();

        if (!sMessage) {
          MessageBox.warning(
            "Enter a question for the AI Assistant."
          );
          return;
        }

        addMessage(
          oHistory,
          "You",
          sMessage
        );

        const sHistory =
          JSON.stringify(aConversationHistory);

        aConversationHistory.push({
          role: "user",
          content: sMessage
        });

        oQuestion.setValue("");
        oQuestion.setEnabled(false);
        oSendButton.setEnabled(false);
        oDialog.setBusy(true);

        try {

          const oAction =
            oModel.bindContext(
              "LogisticsService.askAssistant(...)",
              oContext
            );

          oAction.setParameter(
            "message",
            sMessage
          );

          oAction.setParameter(
            "history",
            sHistory
          );

          await oAction.execute();

          const oResponse =
            oAction
              .getBoundContext()
              .getObject();

          const sAssistantMessage =
            formatResponse(oResponse);

          addMessage(
            oHistory,
            "AI Assistant",
            sAssistantMessage
          );

          aConversationHistory.push({
            role: "assistant",
            content: sAssistantMessage
          });

        }
        catch (oError) {

          console.error(
            "AI Assistant failed:",
            oError
          );

          MessageBox.error(
            oError?.message ||
            "AI Assistant failed"
          );
        }
        finally {
          oDialog.setBusy(false);
          oQuestion.setEnabled(true);
          oSendButton.setEnabled(true);
          oQuestion.focus();
        }
      });

      oDialog.open();
    }
  };
});
