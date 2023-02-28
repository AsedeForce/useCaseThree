/**
 * Created by asedegui on 24/2/2023.
 */

@IsTest
private class MailServiceTest {
    @IsTest
    static void testSendEmails() {
        // Create test contacts
        List<Contact> contacts = TestDataFactory.createSObjectList(
                'Contact', new Map<String,Object>{
                        'LastName' => new List<String>{'Contact 1','Contact 2','Contact 3'},
                        'Email' => new List<String>{'email@1.com', 'email@2.com', 'email@3.com'}
                },3);

        // Create test data
        Map<Id, Contact> contactMap = new Map<Id, Contact>();
        for (Contact c : contacts) {
            contactMap.put(c.Id, c);
        }

        String subject = 'Subject';
        String body = 'Test Body';

        // Call the MailService method
        Test.startTest();
        MailServiceController.sendEmails(contactMap, subject, body);
        System.assertEquals(1, Limits.getEmailInvocations(), 'Should be invoked 1 time');
        Test.stopTest();

    }
}
