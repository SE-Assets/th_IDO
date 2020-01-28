global class tth_GetNextTripDestination {

  private static String CONTACT_PREIX = '003';
  private static String ACCOUNT_PREFIX = '001';
  private static String CHAT_TRANS_PREFIX = '570';

  @InvocableMethod(label='Next Trip Destination' description='Return the Destination for the Travelers next Trip')
  global static List<String> getNextTripDestination(List<String> recordIDs) {
      List<String> locations = new List<String>();
      //contact 003
      //PersonAccount 001
      String contactId;

      for(String curRecId : recordIDs) {
        if ( curRecId.startsWithIgnoreCase(ACCOUNT_PREFIX) ) {
          System.debug('This is an account/person account record');
          Contact accountContact = [SELECT id FROM Contact WHERE AccountId = :curRecId LIMIT 1];
          contactId = accountContact.ID;
        } else if ( curRecId.startsWithIgnoreCase(CONTACT_PREIX) ) {
          System.debug('This is a contact record');
          contactId = curRecId;
        } else if ( curRecId.startsWithIgnoreCase(CHAT_TRANS_PREFIX) ) {
          System.debug('This is a Live Chat Transcript record');
          LiveChatTranscript chatTrans = [SELECT ContactId FROM LiveChatTranscript WHERE Id = :curRecId LIMIT 1];
          contactId = chatTrans.ContactId;
        } else {
          System.debug('No idea what kind of object this is, I was anticipating either an Account, Contact or LiveChat Transcript');
        }
      }

      tth_Trip__c nextTrip = [SELECT tth_Trip_Destination__c FROM tth_Trip__c where ID IN (SELECT tth_Next_Trip__c FROM Contact WHERE ID = :contactId) LIMIT 1];
      locations.add(nextTrip.tth_Trip_Destination__c);
      return locations;
  }
}
