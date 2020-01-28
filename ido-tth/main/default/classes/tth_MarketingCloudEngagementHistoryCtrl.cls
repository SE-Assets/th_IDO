public class tth_MarketingCloudEngagementHistoryCtrl {


    @AuraEnabled
    public static CustomSettingDetails getCustomSettingsData(String customSettingName, String recordId){

        CustomSettingDetails csd = new CustomSettingDetails();
        String soql='';
        if(customSettingName == 'Journeys'){
          csd = getJourneyDetails(customSettingName, recordId);
        }else if (customSettingName == 'Individual Email Results'){
          csd = getEmailResultDetails(customSettingName, recordId);
        }
        system.debug('csd$$$$$' + csd);
       return csd;
    }

    /**
    *
    *
    *
    **/
    private static CustomSettingDetails getJourneyDetails(String customSettingName, String recordId) {
      CustomSettingDetails csd = new CustomSettingDetails();
      String soql='';
      soql = 'SELECT Channel__c, Date_Sent__c , Name_of_Communication__c FROM tth_Mock_MC_Journeys__mdt ORDER BY Order__c ASC';

      System.debug('Inside getJourneyDetails method...');

      csd.colHeaders = new List<string>{'Name of Communication', 'Channel', 'Date Sent'};
      csd.records.addAll(Database.query(soql));


/* THIS IS FOR FUTURE OBJECT SPECIFIC FUNCTIONALITY

      String ORDER_CLAUSE = ' ORDER BY Order__c ASC';
      String labelValue = 'default';
      List<Sobject> queryResults = null;

      SObject so = getObjectFromID(recordId);

      if (so.getSobjectType().getDescribe().fields.getMap().containsKey('External_ID__c')) {
        try {
            sObject objRec = Database.query('SELECT External_ID__c FROM ' + so.get('Name') + ' WHERE ID = \"' + recordId + '\"');
            if (objRec != null  ) {

            } else {
                // Could not find a record with that ID....
                queryResults = null;
            }
        } catch (Exception ex) {
            queryResults = null;
        }
      }

      if (queryResults == null){

      }
      //Using the record ID, first look to see if there are any record specific journey's to use
      // Check what kind of object it is and see if it has an External ID field
      // If it does query to get the external ID and use that to query the custom MEtat data record if there is any record specific FieldSet
      // If there are no record specific fields, just query the default dataset
*/



      return csd;
    }

    /**
    *
    *
    *
    **/
    private static CustomSettingDetails getEmailResultDetails(String customSettingName, String recordId) {
      CustomSettingDetails csd = new CustomSettingDetails();
      String soql='';

      System.debug('Inside getEmailResultDetails method...');

      soql= 'SELECT Bounced__c, Email_Name__c, Date_Sent__c, Opened__c, Clicked__c FROM tth_Mock_MC_Individual_eMail_Results__mdt ORDER BY Order__c ';
      csd.colHeaders = new List<string>{'Email Name', 'Date Sent', 'Opened', 'Clicked', 'Bounced'};
      csd.records.addAll(Database.query(soql));

      return csd;
    }


    private static SObject getObjectFromID(String recordId) {
      ID newID = ID.valueOf(recordId);
      String objName = newID.getSobjectType().getDescribe().getName();
      SObject so = Schema.getGlobalDescribe().get(objName).newSObject();
      return so;
    }


    public class CustomSettingDetails{
        @AuraEnabled
        public List<String> colHeaders{get;set;}
        @AuraEnabled
        public List<Sobject> records{get;set;}
        public customSettingDetails(){
            records = new List<Sobject>();
        }
    }
}
