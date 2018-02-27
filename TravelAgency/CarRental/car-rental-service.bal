package TravelAgency.CarRental;

import ballerina.net.http;
import ballerina.log;

const string AC = "Air Conditioned";
const string Normal = "Normal";

@http:configuration {basePath:"/car", port:9093}
service<http> carRentalService {

    @http:resourceConfig {methods:["POST"], path:"/rent"}
    resource rentCar (http:Connection connection, http:InRequest request) {
        http:OutResponse response = {};
        string name;
        string arrivalDate;
        string departureDate;
        string preferredType;
        try {
            json payload = request.getJsonPayload();
            name = payload.Name.toString();
            arrivalDate = payload.ArrivalDate.toString();
            departureDate = payload.DepartureDate.toString();
            preferredType = payload.Preference.toString().trim();
        } catch (error err) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            _ = connection.respond(response);
            return;
        }

        if (preferredType.equalsIgnoreCase(AC) || preferredType.equalsIgnoreCase(Normal)) {
            log:printInfo("Successfully rented car for user: " + name);
            response.setJsonPayload({"Status":"Success"});
        }
        else {
            log:printWarn("Failed to reserve rent car for user: " + name);
            response.setJsonPayload({"Status":"Failed"});
        }
        _ = connection.respond(response);
    }
}
