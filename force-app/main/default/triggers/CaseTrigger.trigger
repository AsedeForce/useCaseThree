/**
 * Created by asedegui on 21/2/2023.
 */
trigger CaseTrigger on Case (before insert, after update) {
    new CaseTriggerHandler().run();
}