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

    public List<Account> selectByIds(Set<ID> idSet) {
        return (List<Account>) selectSObjectsById(idSet);
    }

    //public List<Account> selectLimitOne()






}