/**
 * Created by asedegui on 23/2/2023.
 */

public with sharing class ExternalSystemController {

    private final ExternalSystemService externalSystemService ;

    public ExternalSystemController() {
        this.externalSystemService = new ExternalSystemService();
    }
    public void registerAttendees(List<Case> newCaseList){
        this.externalSystemService.registerAttendees(newCaseList);
    }

}