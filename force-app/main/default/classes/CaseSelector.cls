/**
 * Created by asedegui on 21/2/2023.
 */

public with sharing class CaseSelector extends fflib_SObjectSelector{

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Case.Id,
                Case.Origin,
                Case.Subject,
                Case.Description,
                Case.AccountId
        };
    }

    public SObjectType getSObjectType() {
        return Case.SObjectType;
    }

    public List<Case> selectById(Set<ID> idSet) {
        return (List<Case>) selectSObjectsById(idSet);
    }

    public List<Case> selectLimit() {
        String query = String.format(
                'SELECT Asset.Parent.Contact.Account.Name, ' +
                        'Asset.Parent.Contact.Account.Description FROM {1} ' +
                        'LIMIT 1',
                new List<String>{ getSObjectName() }
        );
        return Database.query(query);
    }




}