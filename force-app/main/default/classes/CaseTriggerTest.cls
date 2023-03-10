@IsTest
private class CaseTriggerTest {


        @TestSetup
        static void testSetup(){

            Account account = (Account) TestDataFactory.createSObject(
                    'Account', new Map<String,Object>{
                    'Name' => 'Salesforce'
            });

            Account accountWithoutContacts = (Account) TestDataFactory.createSObject(
                    'Account', new Map<String,Object>{
                            'Name' => 'SF'
                    });

            Account accountWitOneContact = (Account) TestDataFactory.createSObject(
                    'Account', new Map<String,Object>{
                            'Name' => 'SF1'
                    });

            List<Contact> contacts = TestDataFactory.createSObjectList(
                    'Contact', new Map<String,Object>{
                            'LastName' => new List<String>{'Contact 1','Contact 2','Contact 3'},
                            'Email' => new List<String>{'emial@1.com', 'emial@2.com', 'emial@3.com'},
                            'AccountId' => account.Id
                    },3);

            Contact contact = (Contact) TestDataFactory.createSObject(
                    'Contact', new Map<String,Object>{
                            'LastName' => 'ContactA',
                            'AccountId' => accountWitOneContact.Id
                    });

            List<Case> cases = TestDataFactory.createSObjectList(
                    'Case', new Map<String,Object>{
                            'Origin' => 'Phone',
                            'AccountId' => account.Id
                    },3);


        }


        @IsTest
        static void refuseCaseCreationWhenAnAccountIsNotAttachedToACase(){
            // Given
            List<Case> cases = new List<Case>();
            for (Integer i = 0; i < 200; i++){
                Case request = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots');
                cases.add(request);
            }

            Test.startTest();
            List<Database.SaveResult> results = Database.insert(cases, false);
            Test.stopTest();


            // Then
            for (Database.SaveResult result : results ) {
                System.assert(!result.isSuccess());
                System.assertEquals('You cannot create a request without attaching an account',
                        result.getErrors()[0].getMessage(), 'You cannot create a request without attaching an account');
            }
        }
        
        @IsTest
        static void refuseCaseCreationWhenNoContactIsAttachedToAnAccount(){

            // Given
            AccountSelector accountSelector = new AccountSelector();
            Account a1 = accountSelector.selectByName('SF')[0];

            // Given
            List<Case> cases = new List<Case>();
            for (Integer i = 0; i < 200; i++){
                Case request = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots', AccountId = a1.Id);
                cases.add(request);
            }

            // When
            Test.startTest();
            List<Database.SaveResult> results = Database.insert(cases, false);
            Test.stopTest();

            // Then
            for (Database.SaveResult result : results ) {
                System.assert(!result.isSuccess());
                System.assertEquals('You cannot create a request for accounts without contacts',
                        result.getErrors()[0].getMessage(), 'You cannot create a request for accounts without contacts');
            }
        }
        
        @IsTest
        static void bookEventFromPhone(){
            // Given
            AccountSelector accountSelector = new AccountSelector();
            Account a1 = accountSelector.selectByName('Salesforce')[0];

            // Given
            List<Case> cases = new List<Case>();
            for (Integer i = 0; i < 200; i++){
                Case request = new Case(Origin = 'Phone',Subject = 'Event Booking', Description = 'Book Spots for Company A1 & their 3 employees', AccountId = a1.Id);
                cases.add(request);
            }

            // When
            Test.startTest();
            List<Database.SaveResult> results = Database.insert(cases, false);
            Test.stopTest();

            // Then
            for (Database.SaveResult result : results ) {
                System.assert(result.isSuccess());
            }


        }


        @IsTest
        static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanThreeForPhoneCases(){
            // Given

            AccountSelector accountSelector = new AccountSelector();
            Account a1 = accountSelector.selectByName('Salesforce')[0];

            Contact c4 = new Contact(LastName = 'Contact 4', AccountId = a1.Id);
            insert c4;

            // Given
            List<Case> cases = new List<Case>();
            for (Integer i = 0; i < 200; i++){
                Case request = new Case(Origin = 'Phone',Subject = 'Event Booking',
                        Description = 'Book Spots for Company A1 & their 4 employees', AccountId = a1.Id);
                cases.add(request);
            }
            // When 

            Test.startTest();
            List<Database.SaveResult> results = Database.insert(cases, false);
            Test.stopTest();

            // Then
            for (Database.SaveResult result : results ) {
                System.assert(!result.isSuccess());
                System.assert(result.getErrors().size() > 0);
                System.assertEquals('Requests coming from the phone should not exceed three attendees.',
                        result.getErrors()[0].getMessage(),
                        'Requests coming from the phone should not exceed three attendees.');
            }

        }
        
        @IsTest
        static void bookEventFromTheWeb(){
            // Given
            AccountSelector accountSelector = new AccountSelector();
            Account a1 = accountSelector.selectByName('SF1')[0];

            // Given
            List<Case> cases = new List<Case>();
            for (Integer i = 0; i < 200; i++){
                Case request = new Case(Origin = 'Web',Subject = 'Event Booking',
                        Description = 'Book One Spot for Company A1', AccountId = a1.Id);
                cases.add(request);
            }

            // When 
            Test.startTest();
            List<Database.SaveResult> results = Database.insert(cases, false);
            Test.stopTest();

            // Then
            for (Database.SaveResult result : results ) {
                System.assert(result.isSuccess());
            }
                
        } 
            
        @IsTest
        static void refuseEventBookingWhenNumberOfAttendeesIsMoreThanOneForWebCases(){
            // Given
            AccountSelector accountSelector = new AccountSelector();
            Account a1 = accountSelector.selectByName('Salesforce')[0];

            // Given
            List<Case> cases = new List<Case>();
            for (Integer i = 0; i < 200; i++){
                Case request = new Case(Origin = 'Web',Subject = 'Event Booking',
                        Description = 'Book Spots for Company A1 & their 3 employees', AccountId = a1.Id);
                cases.add(request);
            }

            // When 
            Test.startTest();
            List<Database.SaveResult> results = Database.insert(cases, false);
            Test.stopTest();

            // Then
            for (Database.SaveResult result : results ) {
                System.assert(!result.isSuccess());
                System.assert(result.getErrors().size() > 0);
                System.assertEquals('Requests coming from the web should not exceed a single attendee.',
                        result.getErrors()[0].getMessage(), 'Requests coming from the web should not exceed a single attendee.');
            }
        }
    
        @IsTest
        static void updateEventCasesToCloseStatusEmailSentTrigger(){

            // Given
            CaseSelector caseSelector = new CaseSelector();
            List<Case> cases = caseSelector.selectByOrigin('Phone');
            ExternalSystemCalloutMock mock = new ExternalSystemCalloutMock(201);

            // updating status to closed
            for (Case c : cases ) {
                c.Status = 'Closed';
            }

            // Associate the mock with the test class
            Test.setMock(HttpCalloutMock.class, mock);

            // When
            Test.startTest();
            List<Database.SaveResult> results = Database.update(cases, true);
            Test.stopTest();

            // Then
            cases = caseSelector.selectByOrigin('Phone');
            for (Database.SaveResult result : results ) {
                System.assert(result.isSuccess());
            }

            List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage WHERE Subject = 'Reservation status CLOSED'];
            System.assertEquals(9, sentEmails.size(), 'Should send 9 Emails');
        }

        @IsTest
        static void updateEventCasesToOtherStatusEmailSentTrigger(){

        // Given
        CaseSelector caseSelector = new CaseSelector();
        List<Case> cases = caseSelector.selectByOrigin('Phone');
        ExternalSystemCalloutMock mock = new ExternalSystemCalloutMock(201);

        // updating status to closed
        for (Case c : cases ) {
            c.Status = 'Open';
        }

        // Associate the mock with the test class
        Test.setMock(HttpCalloutMock.class, mock);

        // When
        Test.startTest();
        List<Database.SaveResult> results = Database.update(cases, true);
        Test.stopTest();

        // Then
        cases = caseSelector.selectByOrigin('Phone');
        for (Database.SaveResult result : results ) {
            System.assert(result.isSuccess());
        }
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage WHERE Subject = 'Reservation status CLOSED'];

        // no Email was sent
        System.assertEquals(0, sentEmails.size(), 'No Emails should be sent.');
    }

    @IsTest
    static void updateEventCasesErrorEmailsNotSent(){

        // Given
        CaseSelector caseSelector = new CaseSelector();
        List<Case> cases = caseSelector.selectByOrigin('Phone');
        ExternalSystemCalloutMock mock = new ExternalSystemCalloutMock(400);

        // updating status to closed
        for (Case c : cases ) {
            c.Status = 'Closed';
        }

        // Associate the mock with the test class
        Test.setMock(HttpCalloutMock.class, mock);

        // When
        Test.startTest();
        List<Database.SaveResult> results = Database.update(cases, true);
        Test.stopTest();

        // Then
        cases = caseSelector.selectByOrigin('Phone');
        for (Database.SaveResult result : results ) {
            System.assert(result.isSuccess());
        }
        List<EmailMessage> sentEmails = [SELECT Id FROM EmailMessage WHERE Subject = 'Reservation status CLOSED'];

        // no Email was sent
        System.assertEquals(0, sentEmails.size(), 'No Emails should be sent.');
    }

}
