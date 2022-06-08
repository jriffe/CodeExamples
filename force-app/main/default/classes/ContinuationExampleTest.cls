@isTest
public with sharing class ContinuationExampleTest {

    public static final string ANIMALS_RESPONSE = '{"animals":["majestic badger","fluffy bunny","scary bear","chicken"]}';
    public static final string ANIMALS_RESPONSE_ADDED = '{"animals":["majestic badger","fluffy bunny","scary bear","chicken", "Antsy Antelope"]}';
    private static String authToken = 'alsdkfhadjfh';
    
    @isTest
    private static void getAnimals_Failure_NoWayToAccessLabel(){
        test.startTest();
        Continuation conti = (Continuation) ContinuationExample1.startFirstRequest();
        test.stopTest();

        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody(ANIMALS_RESPONSE);

        Test.setContinuationResponse('We did not set a label', response);
        //Test.setContinuationResponse('Continuation-1', response);

        List<String> labels = new List<String>{'No Label'};
        //List<String> labels = new List<String>{'Continuation-1'};

        String animals = (String) ContinuationExample1.processResponse(labels, 'state');

        system.assertEquals(ANIMALS_RESPONSE, animals, 'The response was not the expected response.');
    }

    @isTest
    private static void addNewAnimal_Success(){
        test.startTest();
        Continuation conti = (Continuation) ContinuationExample1.startChainedRequest('Antsy Antelope');
        test.stopTest();

        setAuthResponse();

        HttpResponse response = new HttpResponse();
        response.setStatusCode(201);
        response.setBody(ANIMALS_RESPONSE_ADDED);

        Test.setContinuationResponse(ContinuationExample1.addNewAnimalLabel, response);

        List<String> labels = new List<String>{ContinuationExample1.addNewAnimalLabel};

        String animals = (String) ContinuationExample1.processAnimalAddedResponse(labels, 'state');

        system.assertEquals(ANIMALS_RESPONSE_ADDED, animals, 'The response was not the expected response.');
    }

    private static void setAuthResponse(){
        HttpResponse authResponse = new HttpResponse();
        authResponse.setStatusCode(200);
        authResponse.setHeader('Content-Type', 'application/JSON');
        authResponse.setBody('{"access_token":"' + authToken + '"}');

        Test.setContinuationResponse(ContinuationExample1.bearerTokenLabel, authResponse);

        Map<String, Object> callbackParamsState  = new Map<String, Object>();
        callbackParamsState.put('New Animal Name', 'Antsy Antelope');
        callbackParamsState.put('serviceMethod', 'addNewAnimal');

        List<String> labels = new List<String>{ContinuationExample1.bearerTokenLabel};
        Continuation authToken = (Continuation) ContinuationExample1.processAuthorization(labels, callbackParamsState);
    }
}