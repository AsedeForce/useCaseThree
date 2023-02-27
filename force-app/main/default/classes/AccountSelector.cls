/**
 * Created by asedegui on 21/2/2023.
 */

public with sharing class AccountSelector extends fflib_SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Account.Id,
                Account.Description,
                Account.Name,
                Account.OwnerId
        };
    }

    public SObjectType getSObjectType() {
        return Account.SObjectType;
    }

    public List<Account> selectByIds(Set<Id> idSet) {
        return (List<Account>) selectSObjectsById(idSet);
    }

    public List<Account> selectByName(String name) {
        return Database.query(
                newQueryFactory()
                        .setCondition('Name = :name')
                        .selectFields(getSObjectFieldList()).toSOQL()

        );
    }
    public List<Account> selectAccounts() {
        String query = String.format(
                'SELECT {0} FROM {1}',
                new List<String>{ getFieldListString(), getSObjectName() }
        );
        return (List<Account>) Database.query(query);
    }








}