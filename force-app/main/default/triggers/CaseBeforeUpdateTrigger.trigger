trigger CaseBeforeUpdateTrigger on Case (before update, after update) {

    Boolean requestSentToExternalSystem = false;
    Integer i=0;
    
    Case request = Trigger.new[0];

    Case r = [SELECT AccountId, Status FROM Case where id=:request.ID];
    if(r.Status == 'Closed'){
        ExternalSystemService1 service = new ExternalSystemService1();
        service.registerAttendees(r);
    }
}