/**
 * Created by asedegui on 23/2/2023.
 */

public with sharing class MailServiceController {

    public static void sendEmails(Map<Id, Contact> contactMap, String subject, String body) {
        MailService.sendEmails(contactMap, subject, body);
    }

}