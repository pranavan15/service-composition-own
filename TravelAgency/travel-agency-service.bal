package TravelAgency;

import ballerina.net.http;

const string SUCCESS = "Success";
const string FAILED = "Failed";

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
            json inReqPayload = inRequest.getJsonPayload();
            outReqPayload.Name = inReqPayload.Name.toString();
            outReqPayload.ArrivalDate = inReqPayload.ArrivalDate.toString();
            outReqPayload.DepartureDate = inReqPayload.DepartureDate.toString();
            hotelPreference = inReqPayload.Preference.Accommodation;
            airlinePreference = inReqPayload.Preference.Airline;
            carPreference = inReqPayload.Preference.Car;
        } catch (error err) {
            outResponse.statusCode = 400;
            outResponse.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            _ = connection.respond(outResponse);
            return;
        }

        http:OutRequest outReqAirline = {};
        http:OutResponse outResAirline = {};
        json outReqPayloadAirline = outReqPayload;
        outReqPayloadAirline.Preference = airlinePreference;
        outReqAirline.setJsonPayload(outReqPayloadAirline);

        outResAirline, _ = airlineReservationEP.post("/reserve", outReqAirline);
        string airlineReservationStatus = outResAirline.getJsonPayload().Status.toString();
        if (airlineReservationStatus.equalsIgnoreCase(FAILED)) {
            outResponse.setJsonPayload({"Message":"Failed to reserve airline! " +
                                                  "Provide a valid 'Preference' for 'Airline' and try again"});
            _ = connection.respond(outResponse);
            return;
        }

        http:OutRequest outReqHotel = {};
        http:OutResponse outResHotel = {};
        json outReqPayloadHotel = outReqPayload;
        outReqPayloadHotel.Preference = hotelPreference;
        outReqHotel.setJsonPayload(outReqPayloadHotel);

        outResHotel, _ = hotelReservationEP.post("/reserve", outReqHotel);
        string hotelReservationStatus = outResHotel.getJsonPayload().Status.toString();
        if (hotelReservationStatus.equalsIgnoreCase(FAILED)) {
            outResponse.setJsonPayload({"Message":"Failed to reserve hotel! " +
                                                  "Provide a valid 'Preference' for 'Accommodation' and try again"});
            _ = connection.respond(outResponse);
            return;
        }

        http:OutRequest outReqCar = {};
        http:OutResponse outResCar = {};
        json outReqPayloadCar = outReqPayload;
        outReqPayloadCar.Preference = carPreference;
        outReqCar.setJsonPayload(outReqPayloadCar);

        outResCar, _ = carRentalEP.post("/rent", outReqCar);
        string carRentalStatus = outResCar.getJsonPayload().Status.toString();
        if (carRentalStatus.equalsIgnoreCase(FAILED)) {
            outResponse.setJsonPayload({"Message":"Failed to rent car! " +
                                                  "Provide a valid 'Preference' for 'Car' and try again"});
            _ = connection.respond(outResponse);
            return;
        }

        outResponse.setJsonPayload({"Message":"Congratulations! Your journey is ready!!"});
        _ = connection.respond(outResponse);
    }
}
