trigger tthPartyTrigger on tth_Party__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	TriggerDispatcher.Run(new tthPartyTriggerHandler(), Trigger.operationType);
}
