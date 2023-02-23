/**
 * Created by asedegui on 21/2/2023.
 */

public class CaseTriggerHandler extends TriggerHandler{
    private final Map<Id, Case> newCaseMap;

    public CaseTriggerHandler(){
        this.newCaseMap = (Map<Id, Case>) Trigger.newMap;
    }
    public override void beforeInsert() {
        CaseTriggerHelper.beforeInsertWork(this.newCaseMap);
    }
    public override void afterUpdate() {
        CaseTriggerHelper.afterUpdateWork(this.newCaseMap);
    }
}