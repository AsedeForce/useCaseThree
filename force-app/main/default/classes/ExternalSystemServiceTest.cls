/**
 * Created by asedegui on 24/2/2023.
 */

@IsTest
public with sharing class ExternalSystemServiceTest {

    @IsTest
    static void testCallout() {
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

        Case testCase = new Case(AccountId=testAccount.Id);
        List<Case> testCaseList = new List<Case>{testCase};

        ExternalSystemCalloutMock mock = new ExternalSystemCalloutMock();

        // Associate the mock with a test class
        Test.setMock(HttpCalloutMock.class, mock);

        // Create an instance of ExternalSystemService and call registerAttendees()
        ExternalSystemService service = new ExternalSystemService();
        Test.startTest();
        service.registerAttendees(testCaseList);
        System.assertEquals(1, Limits.getEmailInvocations());
        Test.stopTest();

    }

}