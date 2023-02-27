/**
 * Created by asedegui on 24/2/2023.
 */

public with sharing class ExternalSystemCalloutMock implements HttpCalloutMock{

    public HttpResponse respond(HttpRequest request) {
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setHeader('Content-Type', 'application/json;charset=UTF-8');
        mockResponse.setStatusCode(201);

        System.assertEquals('POST', request.getMethod());
        System.assertEquals('application/json;charset=UTF-8', request.getHeader('Content-Type'));
        System.assertEquals('callout:External_System_API', request.getEndpoint());

        // Return the mock response
        return mockResponse;
    }

}