public class FilePreviewController {
	@AuraEnabled
    public static List<ContentDocumentLink> getAllDocumentLinks(string recordId) {
        List<ContentDocumentLink> links = [SELECT 
                                           ContentDocumentId,
                                           ContentDocument.Title, 
                                           ContentDocument.FileType, 
                                           ContentDocument.FileExtension,
                                           ContentDocument.LatestPublishedVersionId,
                                           ContentDocument.Description
                                           FROM ContentDocumentLink 
                                           WHERE LinkedEntityId = :recordId
                                           ORDER BY ContentDocument.ContentModifiedDate DESC
                                          ];
        return links;
    }
    
    
    @AuraEnabled
    public static string postToRecordFeed(string fileName, string fileContent, string recordId)  {
        
        String errorMsg = '';
        
        if (recordId == null || recordId == '') {
            return 'Record Id was null';
        }
        
        try
        {
            ContentVersion version = new ContentVersion();
 			version.Title = fileName;
            version.PathOnClient = 'C:/' + fileName;
            version.VersionData = EncodingUtil.base64Decode(fileContent);
            
            insert version;
            
            version = [SELECT Id,ContentDocumentId FROM ContentVersion WHERE Id=:version.id];
            
            ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
            input.subjectId = recordId;
            
            ConnectApi.FilesCapabilityInput filesInput = new ConnectApi.FilesCapabilityInput();
            filesInput.items = new List<ConnectApi.FileIdInput>();
            
            ConnectAPI.FileIdInput attachFile = new ConnectAPI.FileIDInput();
            
            attachFile.id = version.ContentDocumentId; 
            filesInput.items.add(attachFile);
            
            ConnectApi.FeedElementCapabilitiesInput capabilities = new ConnectApi.FeedElementCapabilitiesInput();
            capabilities.files = filesInput;
            
            input.capabilities = capabilities;
            ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), input);
        }
        catch(Exception e){
            // Handle errors here
            System.debug(e.getMessage());
            errorMsg = e.getMessage();
        }
        return errorMsg;
    }
}