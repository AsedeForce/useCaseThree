/**
 * Created by asedegui on 27/2/2023.
 */

public with sharing class ExternalSystemCalloutService {

    private final String webServiceURL;
    public ExternalSystemCalloutService() {
        this.webServiceURL = 'callout:External_System_API';
    }

    public HttpResponse getResponse( Contact c) {

        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.webServiceURL);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        request.setBody('{"name":"'+ c.Name + '-' + c.Email  +'"}');
        HttpResponse response = new Http().send(request);
        return response;

    }
}