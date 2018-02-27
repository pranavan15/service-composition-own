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

### <a name="unit-testing"></a> Writing Unit Tests 

In ballerina, the unit test cases should be in the same package and the naming convention should be as follows,
* Test files should contain _test.bal suffix.
* Test functions should contain test prefix.
  * e.g.: testBookstoreService()

This guide contains unit test cases for each method implemented in `jms_producer_utils.bal` and `bookstore_service.bal` files.
Test files are in the same packages in which the above files are located.

To run the unit tests, go to the sample root directory and run the following command
   ```bash
   <SAMPLE_ROOT_DIRECTORY>$ ballerina test bookstore/jmsProducer/
   ```

To check the implementations of these test files, please go to https://github.com/ballerina-guides/messaging-with-jms-queues/blob/master/bookstore/jmsProducer/ and refer the respective folders of `jms_producer_utils.bal` and `bookstore_service.bal` files. 

## <a name="deploying-the-scenario"></a> Deployment

Once you are done with the development, you can deploy the service using any of the methods that we listed below. 

### <a name="deploying-on-locally"></a> Deploying Locally
You can deploy the RESTful service that you developed above, in your local environment. You can create the Ballerina executable archive (.balx) first and then run it in your local environment as follows,

Building 
   ```bash
    <SAMPLE_ROOT_DIRECTORY>$ ballerina build bookstore/jmsConsumer/

    <SAMPLE_ROOT_DIRECTORY>$ ballerina build bookstore/jmsProducer/

   ```

Running
   ```bash
    <SAMPLE_ROOT_DIRECTORY>$ ballerina run jmsConsumer.balx 

    <SAMPLE_ROOT_DIRECTORY>$ ballerina run jmsProducer.balx 

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
