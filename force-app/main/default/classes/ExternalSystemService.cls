public with sharing class ExternalSystemService {

    private final String webServiceURL;
    private final AccountSelector accountSelector;
    private final ContactSelector contactSelector;


    public ExternalSystemService(){
        this.webServiceURL = 'callout:External_System_API';
        this.accountSelector = new AccountSelector();
        this.contactSelector = new ContactSelector();
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
                HttpRequest request = new HttpRequest();
                request.setEndpoint(this.webServiceURL);
                request.setMethod('POST');
                request.setHeader('Content-Type', 'application/json;charset=UTF-8');
                // Set the body as a JSON object
                request.setBody('{"name":"'+ c.Name + '-' + c.Email  +'"}');
                HttpResponse response = new Http().send(request);
                // Parse the JSON response
                if (response.getStatusCode() != 201) {
                    // TODO : use the LOGGER
                    System.debug('The status code returned was not expected: ' +
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