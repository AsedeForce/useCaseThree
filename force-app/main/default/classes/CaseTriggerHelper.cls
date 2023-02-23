/**
 * Created by asedegui on 21/2/2023.
 */

public with sharing class CaseTriggerHelper {
    public static void beforeInsertWork(Map<Id, Case> newMapCases){
        // Initializing contactSelector
        ContactSelector contactSelector = new ContactSelector();

        Set<Id> accountIds = new Set<Id>();
        for (Case c : newMapCases.values()) {
            // Check if an account has been linked to the case
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }

        // Get for the number of contacts for each account
        Map<Id, Integer> accountContactCounts = new Map<Id, Integer>();
        for (AggregateResult ar : contactSelector.selectNumberOfContactsByAccountIds(accountIds)) {
            accountContactCounts.put((Id)ar.get('AccountId'), (Integer) ar.get('numberOfContacts'));
        }

        // Validate the number of contacts for each case
        for (Case c : newMapCases.values()) {
            if (c.AccountId != null) {
                Integer numContacts = accountContactCounts.get(c.AccountId);
                if (numContacts == null || numContacts == 0) {
                    c.addError('The attendee linked to this case does not have any companies.');
                } else if (c.Origin == 'Web' && numContacts > 1) {
                    c.addError('Requests coming from the web should not exceed a single attendee.');
                } else if (c.Origin == 'Phone' && numContacts > 3) {
                    c.addError('Requests coming from the phone should not exceed three attendees.');
                }
            }
        }

    }

    public static void afterUpdateWork(Map<Id, Case> newMapCases){

        // Populated with Contacts that are being mailed
        Map<Id, Contact> contactsToSendMailTo = new Map<Id, Contact>();

        ExternalSystemService service = new ExternalSystemService();
        contactsToSendMailTo = service.registerAttendees(newMapCases);

        // Sending Mails trough the mailService
        String subject = 'Reservation status CLOSED';
        String body = 'Your reservation status has been changed to CLOSED';
        MailService.sendEmails(contactsToSendMailTo, subject, body);

    }
}