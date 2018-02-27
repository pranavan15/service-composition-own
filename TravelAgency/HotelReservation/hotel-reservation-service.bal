package TravelAgency.HotelReservation;

import ballerina.net.http;
import ballerina.log;

const string AC = "Air Conditioned";
const string Normal = "Normal";

@http:configuration {basePath:"/hotel", port:9092}
service<http> hotelReservationService {

    @http:resourceConfig {methods:["POST"], path:"/reserve"}
    resource reserveRoom (http:Connection connection, http:InRequest request) {
        http:OutResponse response = {};
        string name;
        string arrivalDate;
        string departureDate;
        string preferredRoomType;
        try {
            json payload = request.getJsonPayload();
            name = payload.Name.toString();
            arrivalDate = payload.ArrivalDate.toString();
            departureDate = payload.DepartureDate.toString();
            preferredRoomType = payload.Preference.toString().trim();
        } catch (error err) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            _ = connection.respond(response);
            return;
        }

        if (preferredRoomType.equalsIgnoreCase(AC) || preferredRoomType.equalsIgnoreCase(Normal)) {
            log:printInfo("Successfully reserved hotel room for user: " + name);
            response.setJsonPayload({"Status":"Success"});
        }
        else {
            log:printWarn("Failed to reserve hotel room for user: " + name);
            response.setJsonPayload({"Status":"Failed"});
        }
        _ = connection.respond(response);
    }
}
