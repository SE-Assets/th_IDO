public class tthBookingTriggerHandler implements ITriggerHandler {

  private tth_Booking_ReservationSettings__mdt metaSettings = null;
  public tthBookingTriggerHandler() {
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
       return metaSettings.BookingTriggersDisabled__c;
     }
    return TriggerDisabled;
    }


	public void BeforeInsert(List<SObject> newItems) {
    caterForSFDXPersonAccounts((tth_Booking__c[])newItems);
    if (metaSettings != null && metaSettings.Generate_Record_Locator__c == true) {
        generateRecordLocator((tth_Booking__c[])newItems);
    }
    if (metaSettings != null && metaSettings.Generate_International_Ticket_Number__c == true) {
      generateTicketNumber((tth_Booking__c[])newItems);
    }
    if (metaSettings != null && metaSettings.Generate_Booking_Reference__c == true) {
      generateBookingReference((tth_Booking__c[])newItems);
    }
  }

	public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

	public void BeforeDelete(Map<Id, SObject> oldItems) {}

	public void AfterInsert(Map<Id, SObject> newItems) {}

	public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

	public void AfterDelete(Map<Id, SObject> oldItems) {}

	public void AfterUndelete(Map<Id, SObject> oldItems) {}

    /**
     *
     *
     *
    **/
    private void generateRecordLocator(List<tth_Booking__c> bookings){
      for(tth_Booking__c curBooking : bookings) {
        String newRecLocator = tth_BookingReservationUtils.generateRecordLocator((Integer)metaSettings.Record_Locator_Length__c);

        //ensure it is unique
        boolean isUniqueRecLocator = false;
        tth_Booking__c bookCheck;
        while(isUniqueRecLocator == false) {
          try {
            bookCheck = [select ID FROM tth_Booking__c WHERE tth_Record_Locator__c =: newRecLocator];
          } catch (Exception ex) {
            // no record found
            bookCheck = null;
          }

          if (bookCheck == null) {
            // No Booking found with same locator, can exit the loop
            isUniqueRecLocator = true;
          } else {
            // Booking found with same Reference so need to try again
            isUniqueRecLocator = false;
          }
        }
        curBooking.tth_Record_Locator__c = newRecLocator;
      }
    }

    /**
     *
     *
     *
    **/
    private void generateTicketNumber(List<tth_Booking__c> reservations){
      for(tth_Booking__c curReservation : reservations) {
        String newTicketNumber = tth_BookingReservationUtils.generateInternationalTicketNumber((Integer)metaSettings.InternationalTicketLength__c);

        if (metaSettings != null && metaSettings.International_Airline_Number__c != '') {
          curReservation.tth_Ticket_ID__c = metaSettings.International_Airline_Number__c + ' ';
        }
        curReservation.tth_Ticket_ID__c += newTicketNumber;
      }
    }

    /**
     *
     *
     *
    **/
    private void generateBookingReference(List<tth_Booking__c> reservations){
      String newBookingReference = '';
      for(tth_Booking__c curReservation : reservations) {
         newBookingReference = tth_BookingReservationUtils.generateBookingReference((Integer)metaSettings.Booking_Reference_Length__c);

        curReservation.tth_Booking_Confirmation__c = newBookingReference;
      }
    }


    /*
      This is mainly to fill a gap in the way SalesforceDX imports data in combo
      with using PersonAccounts and the relationship being on the Contact sObject
     */
    private void caterForSFDXPersonAccounts(tth_Booking__c[] bookingList){
      // Check if the Account field is filled out on the Trip and the contact is NOT
      // Look up the account that is linked and if it is a PersonAccount,
      // grab the Contact ID and update Trip Record with that ID
      for(tth_Booking__c curBooking : bookingList) {
        if (curBooking.tth_Account__c != null && curBooking.tth_Traveler__c == null) {
          Account linkedAcnt = [SELECT ID, PersonContactId, isPersonAccount FROM account where id =: curBooking.tth_Account__c];
          if (linkedAcnt.isPersonAccount) {
            curBooking.tth_Traveler__c = linkedAcnt.PersonContactId;
          }
        }
      }
    }

}
