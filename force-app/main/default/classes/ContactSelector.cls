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
                Contact.LastName
        };
    }

    public List<Contact> selectParentAccountName(){
        return Database.query(
                newQueryFactory()
                        .selectField('Account.Name')
                        .selectField('LastName')
                        .setLimit(1)
                        .toSOQL()
        );
    }

    public List<Contact> selectByAccountId(Id identifier) {
        return Database.query(
                newQueryFactory()
                        .setCondition('AccountId = :identifier')
                        .selectFields(getSObjectFieldList()).toSOQL()

        );
    }

    public List<AggregateResult> selectNumberOfContactsByAccountIds(
            Set<Id> accountIds
    ) {
        String query = String.format(
                'SELECT AccountId, COUNT(Id) numberOfContacts FROM {1} ' +
                        'WHERE AccountId IN :accountIds GROUP BY AccountId',
                new List<String>{ getFieldListString(), getSObjectName() }
        );
        return (List<AggregateResult>) Database.query(query);
    }




}