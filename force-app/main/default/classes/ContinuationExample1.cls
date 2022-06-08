public with sharing class ContinuationExample1 {
    
    // Callout endpoint as a named credential URL
    // or, as shown here, as the long-running service URL
    private static final String LONG_RUNNING_SERVICE_URL = 'https://th-apex-http-callout.herokuapp.com/animals';
    private static final String AUTH_URL = 'https://login.salesforce.com/services/oauth2/token';
    private static String cacheToken = 'local.auth.accesstoken';
    public static Integer DEFAULT_TIMEOUT_IN_SECONDS = 120;
    
    // Action method
    @AuraEnabled(continuation=true cacheable=true)
    public static Object startFirstRequest() {
        // Create continuation. Argument is timeout in seconds.
        Continuation con = new Continuation(DEFAULT_TIMEOUT_IN_SECONDS);
        // Set callback method
        con.continuationMethod = 'processResponse';
        // Set state
        con.state = 'Hello, World!';
        // Create callout request
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(LONG_RUNNING_SERVICE_URL);
        // Add callout request to continuation
        con.addHttpRequest(req);
        // Return the continuation
        return con;
    }
    
    // Callback method
    @AuraEnabled(cacheable=true)
    public static Object processResponse(List<String> labels, Object state) {
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(labels[0]);
        // Set the result variable
        String result = response.getBody();
        return result;
    }

    /****************************************************************************** */

    

    @AuraEnabled(continuation=true)
    public static Object startChainedRequest(String newAnimalName){
        Map<String, Object> serviceParameters = new Map<String, String>();
        serviceParameters.put('New Animal Name', newAnimalName);
        serviceParameters.put('serviceMethod', 'addNewAnimal');

        return getBearerToken(serviceParameters);
    }

    @testVisible
    private static String bearerTokenLabel;
    @testVisible
    private static String bearerTokenState;
    @AuraEnabled(continuation=true)
    public static Object getBearerToken(Map<String, Object> callbackParameters){

        HttpRequest request = new HttpRequest();
        request.setEndpoint(AUTH_URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(getAuthInfo());

        Continuation cont = new Continuation(DEFAULT_TIMEOUT_IN_SECONDS);
        cont.ContinuationMethod = 'processAuthorization';
        bearerTokenLabel = cont.addHttpRequest(request);
        cont.state = callbackParameters;

        return cont;
    }

    @AuraEnabled(continuation=true)
    public static Object processAuthorization(List<String> labels, Object state){
        HttpResponse response = Continuation.getResponse(labels[0]);
        Map<String, Object> callbackParameters = (Map<String, Object>) state;
        try{
            String accessToken = '';
            JSONParser parser = JSON.createParser(response.getBody());
            while( parser.nextToken() != null ) {
                if( parser.getCurrentName() == 'access_token') {
                    accessToken = parser.getText();
                }
            }

            String serviceMethod = (String) callbackParameters.get('serviceMethod');

            Continuation con = new Continuation(DEFAULT_TIMEOUT_IN_SECONDS);
            if(serviceMethod == 'addNewAnimal'){
                con = buildAddNewAnimalContinuation(accessToken, callbackParameters, 'processAnimalAddedResponse');
            }

            return con;

        } catch (Exception e) {
            system.debug('Exception while processing response: ' + response);
            system.debug('Exception caught: ' + e);
            throw e;
        }
    }

    @testVisible 
    private static string addNewAnimalLabel;
    private static Continuation buildAddNewAnimalContinuation(String accessToken, Map<String, Object> callbackParameters, String callbackMethodName){
        String newAnimalName = (String) callbackParameters.get('New Animal Name');

        HttpRequest request = new HttpRequest();
        request.setEndpoint(LONG_RUNNING_SERVICE_URL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setBody('{"name" : "' + newAnimalName + '"}');

        Continuation cont = new Continuation(DEFAULT_TIMEOUT_IN_SECONDS);
        cont.ContinuationMethod = callbackMethodName;
        addNewAnimalLabel = cont.addHttpRequest(request);
        cont.state = 'Adding the Animal';

        return cont;
    }

    @AuraEnabled
    public static Object processAnimalAddedResponse(List<String> labels, Object state){
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(labels[0]);
        // Set the result variable
        String result = response.getBody();
        return result;
    }

    private static String getAuthInfo(){
        API_Setting__mdt setting = [SELECT JSON_Request_Body__c FROM API_Setting__mdt WHERE DeveloperName = 'OAuth_Request'];
        return setting.JSON_Request_Body__c;
    }

    private static void throwCustomException(string message){
        AuraHandledException auraException = new AuraHandledException(message);
        auraException.setMessage(message);
        throw auraException;
    }
}