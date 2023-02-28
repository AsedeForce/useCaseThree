/**
 * Created by asedegui on 21/2/2023.
 */

public with sharing class ContactSelector extends fflib_SObjectSelector{

    public SObjectType getSObjectType() {
        return Contact.SObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Contact.Id,
                Contact.Name,
                Contact.Email,
                Contact.LastName,
                Contact.AccountId
        };
    }

    public List<Contact> selectByAccountId(Id identifier) {
        return Database.query(
                newQueryFactory()
                        .setCondition('AccountId = :identifier')
                        .selectFields(getSObjectFieldList()).toSOQL()

        );
    }

    public List<Contact> selectByAccountIds(Set<Id> identifiers) {
        return Database.query(
                newQueryFactory()
                        .setCondition('AccountId IN :identifiers')
                        .selectFields(getSObjectFieldList()).toSOQL()

        );
    }

    public List<AggregateResult> selectNumberOfContactsByAccountIds(
            Set<Id> accountIds
    ) {
        String query = String.format(
                'SELECT AccountId, COUNT(Id) numberOfContacts FROM {0} ' +
                        'WHERE AccountId IN :accountIds GROUP BY AccountId',
                new List<String>{ getSObjectName() }
        );
        return (List<AggregateResult>) Database.query(query);
    }

    public List<Contact> selectByName(String name) {
        return Database.query(
                newQueryFactory()
                        .setCondition('Name = :name')
                        .selectFields(getSObjectFieldList()).toSOQL()

        );
    }




}