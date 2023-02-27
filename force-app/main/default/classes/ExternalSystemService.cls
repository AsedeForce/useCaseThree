public with sharing class ExternalSystemService {

    private final AccountSelector accountSelector;
    private final ContactSelector contactSelector;
    private final ExternalSystemCalloutService externalSystemCalloutService;


    public ExternalSystemService(){
        this.accountSelector = new AccountSelector();
        this.contactSelector = new ContactSelector();
        this.externalSystemCalloutService = new ExternalSystemCalloutService();
    }

    public void registerAttendees(List<Case> newCaseList){

        // Populated with Contacts that are being mailed
        Map<Id, Contact> contactsToSendMailTo = new Map<Id, Contact>();

        Set<Id> accountIds = new Set<Id>();
        for (Case c : newCaseList) {
            // Check if an account has been linked to the case
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }

        for (Account a : this.accountSelector.selectByIds(accountIds)) {
            for (Contact c : this.contactSelector.selectByAccountId((Id) a.Id)) {
                HttpResponse response = this.externalSystemCalloutService.getResponse(c);
                if (response.getStatusCode() != 201) {
                    Log.error('The status code returned was not expected: ',
                            response.getStatusCode() + ' ' + response.getStatus());
                } else {
                    // Everything went as expected.
                    contactsToSendMailTo.put(c.Id, c);

                }
            }
        }

        if (contactsToSendMailTo.values().size() > 0) {
            // Sending Mails trough the mailServiceController
            String subject = 'Reservation status CLOSED';
            String body = 'Your reservation status has been changed to CLOSED';
            MailServiceController.sendEmails(contactsToSendMailTo, subject, body);
        }

    }
}