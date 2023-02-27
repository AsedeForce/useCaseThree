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

    public List<Case> selectById(Set<Id> idSet) {
        return (List<Case>) selectSObjectsById(idSet);
    }


    public List<Case> selectByOrigin(String origin) {
        return Database.query(
                newQueryFactory()
                        .setCondition('Origin = :origin')
                        .selectFields(getSObjectFieldList()).toSOQL()

        );
    }




}