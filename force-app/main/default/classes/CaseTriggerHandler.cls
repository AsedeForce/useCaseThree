/**
 * Created by asedegui on 21/2/2023.
 */

public class CaseTriggerHandler extends TriggerHandler {
    private final List<Case> newCaseList;

    public CaseTriggerHandler(){
        this.newCaseList = (List<Case>) Trigger.new ;
    }
    public override void beforeInsert() {
        CaseTriggerHelper.beforeInsertWork(this.newCaseList);
    }
    public override void afterUpdate() {
        CaseTriggerHelper.afterUpdateWork(this.newCaseList);
    }
}