/**
 * Created by asedegui on 24/2/2023.
 */

@IsTest
private class ExternalSystemServiceTest {

    @TestSetup
    static void makeData(){

        // Create mock data
        Account testAccount = (Account) TestDataFactory.createSObject(
                'Account', new Map<String,Object>{
                        'Name' => 'SF'
                });

        Contact contact = (Contact) TestDataFactory.createSObject(
                'Contact', new Map<String,Object>{
                        'LastName' => 'ContactA',
                        'Email' => 'a@test.com',
                        'AccountId' => testAccount.Id
                });


    }

    @IsTest
    static void testCalloutOK() {
        ContactSelector cs = new ContactSelector();
        Contact contact = cs.selectByName('ContactA')[0];

        ExternalSystemCalloutMock mock = new ExternalSystemCalloutMock(201);

        // Associate the mock with a test class
        Test.setMock(HttpCalloutMock.class, mock);

        // Create an instance of ExternalSystemServiceCallout and call getResponse()
        ExternalSystemCalloutService service = new ExternalSystemCalloutService();
        Test.startTest();
        HttpResponse response = service.getResponse(contact);
        Test.stopTest();

        System.assertEquals(201, response.getStatusCode(), 'Status code should be 201');

    }

    @IsTest
    static void testCalloutNotOK() {
        ContactSelector cs = new ContactSelector();
        Contact contact = cs.selectByName('ContactA')[0];

        ExternalSystemCalloutMock mock = new ExternalSystemCalloutMock(400);

        // Associate the mock with a test class
        Test.setMock(HttpCalloutMock.class, mock);

        // Create an instance of ExternalSystemServiceCallout and call getResponse()
        ExternalSystemCalloutService service = new ExternalSystemCalloutService();
        Test.startTest();
        HttpResponse response = service.getResponse(contact);
        Test.stopTest();

        System.assertEquals(400, response.getStatusCode(), 'Status code should be 400');

    }

}