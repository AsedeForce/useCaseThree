/**
 * Created by asedegui on 24/2/2023.
 */

public with sharing class ExternalSystemServiceQueueable implements Queueable, Database.AllowsCallouts{

    private List<Case> casesList = new List<Case>();

    public ExternalSystemServiceQueueable(List<Case> casesList){
        this.casesList = casesList;
    }
    public void execute(QueueableContext queueableContext) {
        ExternalSystemController externalSystemController = new ExternalSystemController();
        externalSystemController.registerAttendees(this.casesList);
    }



}