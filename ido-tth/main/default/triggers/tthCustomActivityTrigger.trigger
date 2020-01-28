trigger tthCustomActivityTrigger on Custom_Activity__c (before insert) {
  TriggerDispatcher.Run(new tthCustomActivityTriggerHandler(), Trigger.operationType);
}