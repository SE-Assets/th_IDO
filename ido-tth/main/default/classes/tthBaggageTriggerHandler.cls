public class tthBaggageTriggerHandler implements ITriggerHandler {

  private tth_Booking_ReservationSettings__mdt metaSettings = null;
  public tthBaggageTriggerHandler() {
    metaSettings = tth_BookingReservationUtils.getBookingMetadataSettings();
  }

  /*
    Allows unit tests (or other code) to disable this trigger for the transaction
    To stop this trigger from firing while in a unit test, I could just add the following code to the test:
    AccountTriggerHandler.TriggerDisabled = true;
  */
  public static Boolean TriggerDisabled = false;

  /*
    Checks to see if the trigger has been disabled. For example, you could check a custom setting here.
    In this example, a static property is used to disable the trigger.
    In a unit test, you could use AccountTriggerHandler.TriggerDisabled = true to completely disable the trigger.
  */
	public Boolean IsDisabled() {
    /*
      Use the option below if you set up Custom Settings to controll Triggers
    */
    if(metaSettings != null) {
       return metaSettings.BaggageTriggersDisabled__c;
     }
    return TriggerDisabled;
    }


	public void BeforeInsert(List<SObject> newItems) {
    caterForSFDXPersonAccounts((tth_Baggage__c[])newItems);
  }

	public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

	public void BeforeDelete(Map<Id, SObject> oldItems) {}

	public void AfterInsert(Map<Id, SObject> newItems) {}

	public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

	public void AfterDelete(Map<Id, SObject> oldItems) {}

	public void AfterUndelete(Map<Id, SObject> oldItems) {}

    /*
      This is mainly to fill a gap in the way SalesforceDX imports data in combo
      with using PersonAccounts and the relationship being on the Contact sObject
     */
    private void caterForSFDXPersonAccounts(tth_Baggage__c[] bagList){
      // Check if the Account field is filled out on the Trip and the contact is NOT
      // Look up the account that is linked and if it is a PersonAccount,
      // grab the Contact ID and update Trip Record with that ID
      for(tth_Baggage__c curBag : bagList) {
        if (curBag.tth_Account__c != null && curBag.tth_Traveller__c == null) {
          Account linkedAcnt = [SELECT ID, PersonContactId, isPersonAccount FROM account where id =: curBag.tth_Account__c];
          if (linkedAcnt.isPersonAccount) {
            curBag.tth_Traveller__c = linkedAcnt.PersonContactId;
          }
        }
      }
    }

}
