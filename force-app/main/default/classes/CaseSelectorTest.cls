/**
 * Created by asedegui on 24/2/2023.
 */

@IsTest
private class CaseSelectorTest {

    @TestSetup
    static void makeData() {

        Account account = (Account) TestDataFactory.createSObject(
                'Account', new Map<String,Object>{
                        'Name' => 'Salesforce'
                });

        List<Contact> contacts = TestDataFactory.createSObjectList(
                'Contact', new Map<String,Object>{
                        'LastName' => new List<String>{'Contact 1','Contact 2','Contact 3'},
                        'Email' => new List<String>{'emial@1.com', 'emial@2.com', 'emial@3.com'},
                        'AccountId' => account.Id
                },3);

    }

    @IsTest
    static void testGetSObjectFieldList() {
        CaseSelector selector = new CaseSelector();
        List<Schema.SObjectField> fields = selector.getSObjectFieldList();

        System.assertEquals(Case.Id, fields[0]);
        System.assertEquals(Case.Origin, fields[1]);
        System.assertEquals(Case.Subject, fields[2]);
        System.assertEquals(Case.Description, fields[3]);
        System.assertEquals(Case.AccountId, fields[4]);
    }

    @IsTest
    static void testGetSObjectType() {
        CaseSelector selector = new CaseSelector();
        System.assertEquals(Case.SObjectType, selector.getSObjectType());
    }

    @IsTest
    static void testSelectById() {
        CaseSelector selector = new CaseSelector();
        AccountSelector accountSelector = new AccountSelector();
        Account a = (Account) accountSelector.selectByName('Salesforce')[0];

        Case testCase = new Case(Subject = 'Test Case', AccountId = a.Id);
        insert testCase;

        Set<Id> idSet = new Set<Id>{testCase.Id};
        List<Case> cases = selector.selectById(idSet);

        System.assertEquals(1, cases.size());
        System.assertEquals(testCase.Id, cases[0].Id);
    }

    @IsTest
    static void testSelectByOrigin() {
        CaseSelector selector = new CaseSelector();
        List<Case> cases = selector.selectByOrigin('Web');

        for (Case c : cases) {
            System.assertEquals('Web', c.Origin);
        }
    }
}
