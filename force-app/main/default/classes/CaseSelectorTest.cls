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

        System.assertEquals(Case.Id, fields[0], 'Should find Id field');
        System.assertEquals(Case.Origin, fields[1], 'Should find Origin field');
        System.assertEquals(Case.Subject, fields[2], 'Should find Subject field');
        System.assertEquals(Case.Description, fields[3], 'Should find Description field');
        System.assertEquals(Case.AccountId, fields[4], 'Should find AccountId field');
    }

    @IsTest
    static void testGetSObjectType() {
        CaseSelector selector = new CaseSelector();
        System.assertEquals(Case.SObjectType, selector.getSObjectType(), 'Should be of Case Type');
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

        System.assertEquals(1, cases.size(), 'Should find one case');
        System.assertEquals(testCase.Id, cases[0].Id, 'Should have same Id');
    }

    @IsTest
    static void testSelectByOrigin() {
        CaseSelector selector = new CaseSelector();
        List<Case> cases = selector.selectByOrigin('Web');

        for (Case c : cases) {
            System.assertEquals('Web', c.Origin, 'Should be of Web Origin');
        }
    }
}
