package TravelAgency;

import ballerina.net.http;
import ballerina.log;

@http:configuration {basePath:"/travel", port:9090}
service<http> travelAgencyService {

    endpoint<http:HttpClient> airlineReservationEP {
        create http:HttpClient("http://localhost:9091/airline", {});
    }

    endpoint<http:HttpClient> hotelReservationEP {
        create http:HttpClient("http://localhost:9092/hotel", {});
    }

    endpoint<http:HttpClient> carRentalEP {
        create http:HttpClient("http://localhost:9093/car", {});
    }

    @http:resourceConfig {methods:["POST"]}
    resource arrangeTour (http:Connection connection, http:InRequest inRequest) {

        http:OutResponse outResponse = {};
        json hotelPreference;
        json airlinePreference;
        json carPreference;
        json outReqPayload = {
                                 "Name":"",
                                 "ArrivalDate":"",
                                 "DepartureDate":"",
                                 "Preference":""
                             };
        try {
            log:printInfo("Parsing user request payload");
            json inReqPayload = inRequest.getJsonPayload();
            outReqPayload.Name = inReqPayload.Name.toString();
            outReqPayload.ArrivalDate = inReqPayload.ArrivalDate.toString();
            outReqPayload.DepartureDate = inReqPayload.DepartureDate.toString();
            hotelPreference = inReqPayload.Preference.Accommodation;
            airlinePreference = inReqPayload.Preference.Airline;
            carPreference = inReqPayload.Preference.Car;
            log:printInfo("Successfully parsed; Username: " + outReqPayload.Name);
        } catch (error err) {
            outResponse.statusCode = 400;
            outResponse.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            _ = connection.respond(outResponse);
            log:printWarn("Failed to parse! Bad user request");
            return;
        }

        http:OutRequest outReqAirline = {};
        http:InResponse inResAirline = {};
        json outReqPayloadAirline = outReqPayload;
        outReqPayloadAirline.Preference = airlinePreference;
        outReqAirline.setJsonPayload(outReqPayloadAirline);

        log:printInfo("Reserving airline ticket for user: " + outReqPayload.Name);
        inResAirline, _ = airlineReservationEP.post("/reserve", outReqAirline);
        string airlineReservationStatus = inResAirline.getJsonPayload().Status.toString();
        if (airlineReservationStatus.equalsIgnoreCase("Failed")) {
            outResponse.setJsonPayload({"Message":"Failed to reserve airline! " +
                                                  "Provide a valid 'Preference' for 'Airline' and try again"});
            _ = connection.respond(outResponse);
            log:printWarn("Cannot arrange tour for user: " + outReqPayload.Name + "; Failed to reserve airline ticket");
            return;
        }
        log:printInfo("Airline reservation successful!");

        log:printInfo("Reserving hotel room for user: " + outReqPayload.Name);
        http:OutRequest outReqHotel = {};
        http:InResponse inResHotel = {};
        json outReqPayloadHotel = outReqPayload;
        outReqPayloadHotel.Preference = hotelPreference;
        outReqHotel.setJsonPayload(outReqPayloadHotel);

        inResHotel, _ = hotelReservationEP.post("/reserve", outReqHotel);
        string hotelReservationStatus = inResHotel.getJsonPayload().Status.toString();
        if (hotelReservationStatus.equalsIgnoreCase("Failed")) {
            outResponse.setJsonPayload({"Message":"Failed to reserve hotel! " +
                                                  "Provide a valid 'Preference' for 'Accommodation' and try again"});
            _ = connection.respond(outResponse);
            log:printWarn("Cannot arrange tour for user: " + outReqPayload.Name + "; Failed to reserve hotel room");
            return;
        }
        log:printInfo("Hotel reservation successful!");

        log:printInfo("Renting car for user: " + outReqPayload.Name);
        http:OutRequest outReqCar = {};
        http:InResponse inResCar = {};
        json outReqPayloadCar = outReqPayload;
        outReqPayloadCar.Preference = carPreference;
        outReqCar.setJsonPayload(outReqPayloadCar);

        inResCar, _ = carRentalEP.post("/rent", outReqCar);
        string carRentalStatus = inResCar.getJsonPayload().Status.toString();
        if (carRentalStatus.equalsIgnoreCase("Failed")) {
            outResponse.setJsonPayload({"Message":"Failed to rent car! " +
                                                  "Provide a valid 'Preference' for 'Car' and try again"});
            _ = connection.respond(outResponse);
            log:printWarn("Cannot arrange tour for user: " + outReqPayload.Name + "; Failed to rent car");
            return;
        }
        log:printInfo("Car rental successful!");

        outResponse.setJsonPayload({"Message":"Congratulations! Your journey is ready!!"});
        _ = connection.respond(outResponse);
        log:printInfo("Successfully arranged tour for user: " + outReqPayload.Name + "!!");
    }
}
