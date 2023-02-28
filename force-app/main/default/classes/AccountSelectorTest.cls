@IsTest
private class AccountSelectorTest {

    @TestSetup
    static void makeData() {

        Account account = (Account) TestDataFactory.createSObject(
                'Account', new Map<String,Object>{
                        'Name' => 'Test Account'
                });
    }

    @IsTest
    static void testGetSObjectFieldList() {
        AccountSelector selector = new AccountSelector();
        List<Schema.SObjectField> fields = selector.getSObjectFieldList();

        System.assertEquals(Account.Id, fields[0], 'Should be Id field');
        System.assertEquals(Account.Description, fields[1], 'Should be Description field');
        System.assertEquals(Account.Name, fields[2], 'Should be Name field');
        System.assertEquals(Account.OwnerId, fields[3], 'Should be OwnerId field');
    }

    @IsTest
    static void testGetSObjectType() {
        AccountSelector selector = new AccountSelector();
        System.assertEquals(Account.SObjectType, selector.getSObjectType());
    }

    @IsTest
    static void testSelectByIds() {
        AccountSelector selector = new AccountSelector();
        Account testAccount = [SELECT Id FROM Account LIMIT 1];

        Set<Id> idSet = new Set<Id>{testAccount.Id};
        List<Account> accounts = selector.selectByIds(idSet);

        System.assertEquals(1, accounts.size(), 'Account size should be 1');
        System.assertEquals(testAccount.Id, accounts[0].Id, 'Account Id should be the same');
    }

    @IsTest
    static void testSelectByName() {
        AccountSelector selector = new AccountSelector();
        List<Account> accounts2 = [ SELECT Id, Name FROM Account WHERE Name = 'Test Account' ];
        List<Account> accounts = selector.selectByName('Test Account');

        System.assertEquals(1, accounts.size(), 'Accounts size Should be 1');
        System.assertEquals(accounts2[0].Id, accounts[0].Id, 'Account Id Should be the same');
        System.assertEquals(accounts2[0].Name, accounts[0].Name, 'Account Name should be the same');
    }
}