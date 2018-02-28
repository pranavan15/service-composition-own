# Service Composition

## <a name="what-you-build"></a>  What you’ll Build


![alt text](https://github.com/pranavan15/service-composition/blob/master/images/serviceComposition.png)


## <a name="pre-req"></a> Prerequisites
 
- JDK 1.8 or later
- Ballerina Distribution (Install Instructions:  https://ballerinalang.org/docs/quick-tour/quick-tour/#install-ballerina)
- A Text Editor or an IDE 

Optional Requirements
- Docker (Follow instructions in https://docs.docker.com/engine/installation/)
- Ballerina IDE plugins. ( IntelliJ IDEA, VSCode, Atom)
- Testerina (Refer: https://github.com/ballerinalang/testerina)
- Container-support (Refer: https://github.com/ballerinalang/container-support)
- Docerina (Refer: https://github.com/ballerinalang/docerina)

## <a name="developing-service"></a> Developing the Service

### <a name="before-begin"></a> Before You Begin
##### Understand the Package Structure
Ballerina is a complete programming language that can have any custom project structure as you wish. Although language allows you to have any package structure, we'll stick with the following package structure for this project.

```
service-composition
├── TravelAgency
│   ├── AirlineReservation
│   │   ├── airline_reservation_service.bal
│   │   └── airline_reservation_service_test.bal
│   ├── CarRental
│   │   ├── car_rental_service.bal
│   │   └── car_rental_service_test.bal
│   ├── HotelReservation
│   │   ├── hotel_reservation_service.bal
│   │   └── hotel_reservation_service_test.bal
│   ├── travel_agency_service.bal
│   └── travel_agency_service_test.bal
└── README.md

```

### <a name="Implementation"></a> Implementation

## <a name="testing"></a> Testing 

### <a name="try-it"></a> Try it Out

1. Start all 4 http services by entering the following commands in sperate terminals. This will start the `Airline Reservation`, `Hotel Reservation`, `Car Rental` and `Travel Agency` services in ports 9091, 9092, 9093 and 9090 respectively.

   ```bash
    <SAMPLE_ROOT_DIRECTORY>$ ballerina run TravelAgency/AirlineReservation/
   ```
   ```bash
    <SAMPLE_ROOT_DIRECTORY>$ ballerina run TravelAgency/HotelReservation/
   ```
   ```bash
    <SAMPLE_ROOT_DIRECTORY>$ ballerina run TravelAgency/CarRental/
   ```
   ```bash
    <SAMPLE_ROOT_DIRECTORY>$ ballerina run TravelAgency/
   ```
   
2. Invoke the `travelAgencyService` by sending a POST request to arrange a tour,

   ```bash
    curl -v -X POST -d \
    '{"Name":"Alice", "ArrivalDate":"12-03-2018", "DepartureDate":"13-04-2018",
      "Preference":{"Airline":"Business", "Accommodation":"Air Conditioned", "Car":"Air Conditioned"}}' \
     "http://localhost:9090/travel/arrangeTour" -H "Content-Type:application/json"
    ```

    The `travelAgencyService` should respond something similar,
    
    ```bash
     < HTTP/1.1 200 OK
    {"Message":"Congratulations! Your journey is ready!!"}
    ``` 

   Sample Log Messages
   
   ```
    2018-02-28 10:34:14,198 INFO  [TravelAgency] - Parsing request payload 
    2018-02-28 10:34:14,201 INFO  [TravelAgency] - Successfully parsed; Username: Alice 
    2018-02-28 10:34:14,203 INFO  [TravelAgency] - Reserving airline ticket for user: Alice
    
    2018-02-28 10:33:18,381 INFO  [TravelAgency.AirlineReservation] - Successfully reserved airline ticket for user: Alice
    
    2018-02-28 10:34:14,217 INFO  [TravelAgency] - Airline reservation successful! 
    2018-02-28 10:34:14,217 INFO  [TravelAgency] - Reserving hotel room for user: Alice
    
    2018-02-28 10:33:18,645 INFO  [TravelAgency.HotelReservation] - Successfully reserved hotel room for user: Alice 
    
    2018-02-28 10:34:14,225 INFO  [TravelAgency] - Hotel reservation successful! 
    2018-02-28 10:34:14,225 INFO  [TravelAgency] - Renting car for user: Alice
    
    2018-02-28 10:33:18,906 INFO  [TravelAgency.CarRental] - Successfully rented car for user: Alice
    
    2018-02-28 10:34:14,233 INFO  [TravelAgency] - Car rental successful! 
    2018-02-28 10:34:14,235 INFO  [TravelAgency] - Successfully arranged tour for user: Alice !!    
   ```
   
   
### <a name="unit-testing"></a> Writing Unit Tests 

In ballerina, the unit test cases should be in the same package and the naming convention should be as follows,
* Test files should contain _test.bal suffix.
* Test functions should contain test prefix.
  * e.g.: testTravelAgencyService()

This guide contains unit test cases for each service implemented above. 

Test files are in the same packages in which the service files are located.

To run the unit tests, go to the sample root directory and run the following command
   ```bash
   <SAMPLE_ROOT_DIRECTORY>$ ballerina test TravelAgency/
   ```

To check the implementations of these test files, please go to https://github.com/ballerina-guides/service-composition/blob/master/TravelAgency/ and refer the respective folders of `airline_reservation_service.bal`,
`car_rental_service.bal`, `hotel_reservation_service.bal` and `travel_agency_service.bal` files. 

## <a name="deploying-the-scenario"></a> Deployment

Once you are done with the development, you can deploy the services using any of the methods that we listed below. 

### <a name="deploying-on-locally"></a> Deploying Locally
You can deploy the RESTful services that you developed above, in your local environment. You can create the Ballerina executable archives (.balx) first and then run them in your local environment as follows,

Building 
   ```bash
    <SAMPLE_ROOT_DIRECTORY>$ ballerina build TravelAgency/AirlineReservation/

    <SAMPLE_ROOT_DIRECTORY>$ ballerina build TravelAgency/HotelReservation/

    <SAMPLE_ROOT_DIRECTORY>$ ballerina build TravelAgency/CarRental/
    
    <SAMPLE_ROOT_DIRECTORY>$ ballerina build TravelAgency/

   ```

Running
   ```bash
    <SAMPLE_ROOT_DIRECTORY>$ ballerina run AirlineReservation.balx
    
    <SAMPLE_ROOT_DIRECTORY>$ ballerina run HotelReservation.balx 

    <SAMPLE_ROOT_DIRECTORY>$ ballerina run CarRental.balx
     
    <SAMPLE_ROOT_DIRECTORY>$ ballerina run TravelAgency.balx

   ```

### <a name="deploying-on-docker"></a> Deploying on Docker
(Work in progress) 

### <a name="deploying-on-k8s"></a> Deploying on Kubernetes
(Work in progress) 


## <a name="observability"></a> Observability 

### <a name="logging"></a> Logging
(Work in progress) 

### <a name="metrics"></a> Metrics
(Work in progress) 


### <a name="tracing"></a> Tracing 
(Work in progress) 
