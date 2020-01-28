trigger tthTripTrigger on tth_Trip__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	TriggerDispatcher.Run(new tthTripTriggerHandler(), Trigger.operationType);
}