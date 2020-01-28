public class tth_CustomActivityController {

    @AuraEnabled
    public static List <Custom_Activity__c> getActivitiesForObject(Id recordId, String relationshipField, String objectType) {
        String query = 'SELECT Id,Name,message__c,icon__c,Icon_Color__c,days_ago__c,time__c,order__c ';
		    query += 'FROM Custom_Activity__c WHERE ' + relationshipField + ' = \'' + recordId + '\' ';
        query += 'ORDER BY order__c ASC';
        List<Custom_Activity__c> a = Database.query(query);
        return a;
    }


    @AuraEnabled
    public static List <Custom_Activity__c> getActivitiesForTrip(Id recordId) {
        List<Custom_Activity__c> a = [
            SELECT Id,Name,message__c,icon__c,Icon_Color__c,days_ago__c,time__c,order__c
            FROM Custom_Activity__c
            WHERE tth_Trip__c = :recordId
            ORDER BY order__c ASC
        ];
        return a;
    }


    @AuraEnabled
    public static List <Custom_Activity__c> getActivitiesForContact(Id recordId) {


      System.debug('**** getting ActivitiesForContact with recordID: ' + recordId);

        List<Custom_Activity__c> a = [
            SELECT Id,Name,message__c,icon__c,Icon_Color__c,days_ago__c,time__c,order__c
            FROM Custom_Activity__c
            WHERE contact__c = :recordId
            ORDER BY order__c ASC
        ];
        return a;
    }

    @AuraEnabled
    public static List <Custom_Activity__c> getActivitiesForAccount(Id recordId) {
        List<Custom_Activity__c> a = [
            SELECT Id,Name,message__c,icon__c,Icon_Color__c,days_ago__c,time__c,order__c
            FROM Custom_Activity__c
            WHERE contact__c in (SELECT PersonContactId FROM Account WHERE Id = :recordId)
            ORDER BY order__c ASC
        ];
        return a;
    }

    @AuraEnabled
    public static Account getContactForAccount (Id recordId) {
        Account a = [SELECT PersonContactId FROM Account where Id = :recordId ];
       	return a;
    }

    @AuraEnabled
    public static LiveChatTranscript getContactForChat(ID recordId) {

      System.debug('***** inside getContactForChat for recordID: ' + recordId);

      LiveChatTranscript chat = [SELECT ContactId FROM LiveChatTranscript WHERE id =: recordId];

      System.debug('***** inside getContactForChat ContactID is: ' + chat.ContactId);

      return chat;
    }


    @AuraEnabled
    public static List <Custom_Activity__c> getActivitiesForLiveChat(Id recordId) {


        List<Custom_Activity__c> a = [
            SELECT Id,Name,message__c,icon__c,Icon_Color__c,days_ago__c,time__c,order__c
            FROM Custom_Activity__c
            WHERE contact__c in (SELECT contactId FROM LiveChatTranscript WHERE Id = :recordId)
            ORDER BY order__c ASC
        ];
        return a;
    }





}
