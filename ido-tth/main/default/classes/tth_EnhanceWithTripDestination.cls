global class tth_EnhanceWithTripDestination {

  private static String CONTACT_PREIX = '003';
  private static String ACCOUNT_PREFIX = '001';
  private static String CHAT_TRANS_PREFIX = '570';


  global class DataContainer {
      @InvocableVariable
      public string recordId;

      @InvocableVariable
      public List<Recommendation> recommendations;
  }


  @InvocableMethod(label='Enhance with Next Destination' description='Looks at the travelers next trip destination and appends "in location" to the end of each recommendation')
  global static List<List<Recommendation>> enhanceWithDestination(List<DataContainer> inputData) {
      List<List<Recommendation>> outputs = new List<List<Recommendation>>();
      List<Recommendation> editedRecomendations = new List<Recommendation>();

      for (DataContainer curInput : inputData) {
        String nextTripLocation = getNextTripLocation(curInput.recordId);
        List<Recommendation> recommendations = curInput.recommendations;

        for(Recommendation curRec : recommendations) {
          curRec.Description += ' in ' + nextTripLocation;
          editedRecomendations.add(curRec);
        }
      }
      outputs.add(editedRecomendations);
      return outputs;
  }


  private static String getNextTripLocation(String recordId){
    String contactId;
    if ( recordId.startsWithIgnoreCase(ACCOUNT_PREFIX) ) {
      System.debug('This is an account/person account record');
      Contact accountContact = [SELECT id FROM Contact WHERE AccountId = :recordId LIMIT 1];
      contactId = accountContact.ID;
    } else if ( recordId.startsWithIgnoreCase(CONTACT_PREIX) ) {
      System.debug('This is a contact record');
      contactId = recordId;
    } else if ( recordId.startsWithIgnoreCase(CHAT_TRANS_PREFIX) ) {
      System.debug('This is a LiveChat Transcript record');
      LiveChatTranscript chatTrans = [SELECT ContactId FROM LiveChatTranscript WHERE Id = :recordId LIMIT 1];
      contactId = chatTrans.ContactId;
    } else {
      System.debug('No idea what kind of object this is, I was anticipating either an Account or Contact');
    }
    tth_Trip__c nextTrip = [SELECT tth_Trip_Destination__c FROM tth_Trip__c where ID IN (SELECT tth_Next_Trip__c FROM Contact WHERE ID = :contactId) LIMIT 1];
    return nextTrip.tth_Trip_Destination__c;
  }


}
