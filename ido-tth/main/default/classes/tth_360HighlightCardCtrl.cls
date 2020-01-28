public class tth_360HighlightCardCtrl {
    public tth_360HighlightCardCtrl() {

    }

    @AuraEnabled
    public static Contact get360SummaryForRecord(Id recordId, String sObjectName, String[] contactFields) {
        Contact contactRecord = null;
        String contactId = null;
        String queryFeilds = String.join(contactFields, ',');

        String query = 'SELECT ' + queryFeilds + ' FROM Contact WHERE id = :contactId LIMIT 1';


        System.debug('------- tth_360HighlightCardCtrl.get360SummaryForRecord recordId: ' + recordId);
        System.debug('------- tth_360HighlightCardCtrl.get360SummaryForRecord sObjectName: ' + sObjectName);
        System.debug('------- tth_360HighlightCardCtrl.get360SummaryForRecord fields: ' + queryFeilds);
        System.debug('------- tth_360HighlightCardCtrl.get360SummaryForRecord query: ' + query);

        // Deterine what kind of object this is
        // Figure out how to extract the Contact ID from that record
        // Query and pull out the fields

        if ( sObjectName == 'Account') {
          Account pAccount = [SELECT PersonContactId FROM Account WHERE id = :recordId];
          contactId = pAccount.PersonContactId;
        } else if (sObjectName == 'LiveChatTranscript') {
          LiveChatTranscript chatTrans = [SELECT ContactId FROM LiveChatTranscript WHERE id = :recordId];
          contactId = chatTrans.ContactId;
        } else if (sObjectName == 'Contact') {
          contactId = String.valueof(recordId);
        }

        if (contactId != null) {
            contactRecord = Database.query(query);
        }
        return contactRecord;
    }
}
