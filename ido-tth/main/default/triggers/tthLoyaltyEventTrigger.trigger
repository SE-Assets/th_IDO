trigger tthLoyaltyEventTrigger on tth_Loyalty_Event__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerDispatcher.Run(new tthLoyaltyEventTriggerHandler(), Trigger.operationType);
}