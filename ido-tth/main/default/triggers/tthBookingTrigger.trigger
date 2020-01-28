trigger tthBookingTrigger on tth_Booking__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
  TriggerDispatcher.Run(new tthBookingTriggerHandler(), Trigger.operationType);
}
