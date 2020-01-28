public class tthLoyaltyEventTriggerHandler implements ITriggerHandler {
  /*
    Allows unit tests (or other code) to disable this trigger for the transaction
    To stop this trigger from firing while in a unit test, I could just add the following code to the test:
    AccountTriggerHandler.TriggerDisabled = true;
  */
  public static Boolean TriggerDisabled = false;

  public tthLoyaltyEventTriggerHandler() { }


  /*
    Checks to see if the trigger has been disabled. For example, you could check a custom setting here.
    In this example, a static property is used to disable the trigger.
    In a unit test, you could use AccountTriggerHandler.TriggerDisabled = true to completely disable the trigger.
  */
  public Boolean IsDisabled() {
    /*
      Use the option below if you set up Custom Settings to controll Triggers
    */
    tth_LoyaltySettings__mdt triggerSetting;
    try {
      triggerSetting = [SELECT LoyaltyEventTriggersDisabled__c FROM tth_LoyaltySettings__mdt WHERE label = 'default'];
    } catch (Exception ex) {
      triggerSetting = null;
    }

    if(triggerSetting != null) {
       return triggerSetting.LoyaltyEventTriggersDisabled__c;
     }
    return TriggerDisabled;
  }

  public void BeforeInsert(List<SObject> newItems) {
    caterForSFDXPersonAccounts((tth_Loyalty_Event__c[])newItems);
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
  private void caterForSFDXPersonAccounts(tth_Loyalty_Event__c[] loyaltyEventList){
    // Check if the Account field is filled out on the LoyaltyEvent and the contact is NOT
    // Look up the account that is linked and if it is a PersonAccount,
    // grab the Contact ID and update LoyaltyEvent Record with that ID
    for(tth_Loyalty_Event__c curEvent : loyaltyEventList) {
      if (curEvent.tth_Account__c != null && curEvent.tth_traveler__c == null) {
        Account linkedAcnt = [SELECT ID, PersonContactId, isPersonAccount FROM account where id =: curEvent.tth_Account__c];
        if (linkedAcnt.isPersonAccount) {
          curEvent.tth_traveler__c = linkedAcnt.PersonContactId;
        }
      }
    }
  }

}
