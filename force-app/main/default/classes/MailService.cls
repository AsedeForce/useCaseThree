/**
 * Created by asedegui on 22/2/2023.
 */

public class MailService {
    public static void sendEmails(Map<Id, Contact> contactMap, String subject, String body) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Contact contact : contactMap.values()) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new List<String>{contact.Email});
            email.setSubject(subject);
            email.setHtmlBody(body);
            emails.add(email);
        }

        Messaging.sendEmail(emails);
    }
}
