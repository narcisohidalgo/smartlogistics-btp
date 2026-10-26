import com.sap.gateway.ip.core.customdev.util.Message
import groovy.json.JsonOutput
import groovy.json.JsonSlurper

def Message processData(Message message) {

    def reader = message.getBody(java.io.Reader)
    def input = new JsonSlurper().parse(reader)

    def output = [
        shipmentNumber     : "SHP-${input.purchaseOrderId}",
        purchaseOrderId    : input.purchaseOrderId,
        carrier            : "DHL",
        trackingNumber     : "AUTO-${input.purchaseOrderId}",
        originCountry      : "ESP",
        originCity         : "Cordoba",
        destinationCountry : "ESP",
        destinationCity    : "Madrid",
        plannedDeparture   : "${input.orderDate}T08:00:00Z",
        plannedArrival     : "${input.deliveryDate}T16:00:00Z",
        status             : "PLANNED"
    ]

    message.setHeader("Content-Type", "application/json")
    message.setBody(JsonOutput.toJson(output))

    return message
}
