package TravelAgency.AirlineReservation;

import ballerina.net.http;

const string ECONOMY = "Economy";
const string BUSINESS = "Business";
const string FIRST = "First";

@http:configuration {basePath:"/airline", port:9091}
service<http> airlineReservationService {

    @http:resourceConfig {methods:["POST"], path:"/reserve"}
    resource reserveTicket (http:Connection connection, http:InRequest request) {
        http:OutResponse response = {};
        string name;
        string arrivalDate;
        string departureDate;
        string preferredClass;
        try {
            json payload = request.getJsonPayload();
            name = payload.Name.toString();
            arrivalDate = payload.ArrivalDate.toString();
            departureDate = payload.DepartureDate.toString();
            preferredClass = payload.Preference.toString().trim();
        } catch (error err) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            _ = connection.respond(response);
            return;
        }

        if (preferredClass.equalsIgnoreCase(ECONOMY) || preferredClass.equalsIgnoreCase(BUSINESS) ||
                                                          preferredClass.equalsIgnoreCase(FIRST)) {
            response.setJsonPayload({"Status":"Success"});
        }
        else {
            response.setJsonPayload({"Status":"Failed"});
        }
        _ = connection.respond(response);
    }
}
