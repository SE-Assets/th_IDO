public class tth_BookingReservationUtils {

  /**
   *
   *
   *
   **/
  public static String generateBookingReference(Integer recordLength) {
      return generateRandomNumber(recordLength);
  }


    /**
     *
     *
     *
     **/
    public static String generateRecordLocator(Integer recordLength) {
        return generateRandomString(recordLength);
    }

    /**
     *
     *
     *
     **/
    public static String generateInternationalTicketNumber(Integer recordLength) {
      return generateRandomNumber(recordLength);
    }

    /**
     *
     *
     *
     **/
    public static tth_Booking_ReservationSettings__mdt getBookingMetadataSettings() {
      tth_Booking_ReservationSettings__mdt metaSettings = null;

      try {
        metaSettings = [SELECT BookingTriggersDisabled__c, TripTriggersDisabled__c,
                        BaggageTriggersDisabled__c, PartyTriggersDisabled__c,
                        Generate_Record_Locator__c, Record_Locator_Length__c,
                        Generate_Booking_Reference__c, Booking_Reference_Length__c,
                        Generate_International_Ticket_Number__c, International_Airline_Number__c, InternationalTicketLength__c
                        FROM tth_Booking_ReservationSettings__mdt
                        WHERE label = 'default'];
      } catch (Exception ex) {
        metaSettings = null;
      }
      return metaSettings;
    }




   /**
     *
     *
     *
     **/
    private static String generateRandomString(Integer len) {
        final String chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 32);
           randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }


    /**
      *
      *
      *
      **/
    private static String generateRandomNumber(Integer len) {
      final String chars = '1234567890';
      String randStr = '';
      while (randStr.length() < len) {
         Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 10);
         randStr += chars.substring(idx, idx+1);
      }
      return randStr;
    }

}
