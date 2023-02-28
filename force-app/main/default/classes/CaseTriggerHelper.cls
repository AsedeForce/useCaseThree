/**
 * Created by asedegui on 21/2/2023.
 */

public with sharing class CaseTriggerHelper {
    public static void beforeInsertWork(List<Case> newCaseList){
        // Initializing contactSelector
        ContactSelector contactSelector = new ContactSelector();

        Set<Id> accountIds = new Set<Id>();
        for (Case c : (List<Case>) newCaseList) {
            // Check if an account has been linked to the case
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            } else {
                c.addError('You cannot create a request without attaching an account');
            }
        }

        // Get for the number of contacts for each account
        Map<Id, Integer> accountContactCounts = new Map<Id, Integer>();
        for (AggregateResult ar : contactSelector.selectNumberOfContactsByAccountIds(accountIds)) {
            accountContactCounts.put((Id)ar.get('AccountId'), (Integer) ar.get('numberOfContacts'));
        }

        // Validate the number of contacts for each case
        for (Case c : newCaseList) {
            if (c.AccountId != null) {
                Integer numContacts = accountContactCounts.get(c.AccountId);
                if (numContacts == null || numContacts == 0) {
                    c.addError('You cannot create a request for accounts without contacts');
                } else if (c.Origin == 'Web' && numContacts > 1) {
                    c.addError('Requests coming from the web should not exceed a single attendee.');
                } else if (c.Origin == 'Phone' && numContacts > 3) {
                    c.addError('Requests coming from the phone should not exceed three attendees.');
                }
            }
        }

    }

    public static void afterUpdateWork(List<Case> newCaseList){
        for (Case c : newCaseList){
            if ( c.Status == 'Closed' ){

                // Sending message trough external system QUEUE
                ExternalSystemServiceQueueable queueable = new ExternalSystemServiceQueueable(newCaseList);
                System.enqueueJob(queueable);

            }

        }




    }
}