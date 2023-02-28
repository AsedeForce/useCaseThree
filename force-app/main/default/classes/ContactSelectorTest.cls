/**
 * Created by asedegui on 24/2/2023.
 */

@IsTest
private class ContactSelectorTest {

    @TestSetup
    static void testSetup() {

        Account account = (Account) TestDataFactory.createSObject(
                'Account', new Map<String,Object>{
                        'Name' => 'Salesforce'
                });
        Account account2 = (Account) TestDataFactory.createSObject(
                'Account', new Map<String,Object>{
                        'Name' => 'SF'
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
                        'AccountId' => account2.Id
                });

    }

    @IsTest
    static void testSelectByAccountId() {
        AccountSelector ac = new AccountSelector();
        Account testAccount = ac.selectByName('Salesforce')[0];
        ContactSelector selector = new ContactSelector();

        List<Contact> results = selector.selectByAccountId(testAccount.Id);

        System.assertEquals(3, results.size(), 'Should equal 3');
        for (Contact c : results) {
            System.assertEquals(testAccount.Id, c.AccountId);
        }
    }

    @IsTest
    static void testSelectByAccountIds() {
        AccountSelector ac = new AccountSelector();
        List<Account> testAccounts = ac.selectAccounts();
        Set<Id> accountIds = new Set<Id>();
        for (Account a : testAccounts) {
            accountIds.add(a.Id);
        }
        ContactSelector selector = new ContactSelector();

        List<Contact> results = selector.selectByAccountIds(accountIds);

        System.assertEquals(4, results.size(), 'Should be of size 4');
        for (Contact c : results) {
            System.assert(accountIds.contains(c.AccountId));
        }
    }

    @IsTest
    static void testSelectNumberOfContactsByAccountIds() {
        List<Account> testAccounts = new AccountSelector().selectAccounts();
        Set<Id> accountIds = new Set<Id>();
        for (Account a : testAccounts) {
            accountIds.add(a.Id);
        }
        ContactSelector selector = new ContactSelector();

        List<AggregateResult> results = selector.selectNumberOfContactsByAccountIds(accountIds);

        System.assertEquals(2, results.size(), 'Should be of size 2');
        System.assert(accountIds.contains((Id) results[0].get('AccountId')));
        System.assertEquals(3, (Integer) results[0].get('numberOfContacts'), 'Should be 3');
        System.assert(accountIds.contains((Id) results[1].get('AccountId')));
        System.assertEquals(1, (Integer) results[1].get('numberOfContacts'), 'Should be 1');

    }

    @IsTest
    static void testSelectByName() {
        ContactSelector selector = new ContactSelector();

        List<Contact> results = selector.selectByName('Contact 1');

        System.assertEquals(1, results.size(), 'size should be one');
        System.assertEquals('Contact 1', results[0].LastName, 'Should equal Contact 1');
    }
}
