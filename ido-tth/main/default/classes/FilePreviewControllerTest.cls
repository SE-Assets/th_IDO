@isTest
public class FilePreviewControllerTest {
	@isTest(SeeAllData=true)
    static void postToRecordFeedTest() {
        Account test = new Account();
        test.Name = 'Test Account';
        insert test;
        
        Blob testFile = Blob.valueOf('Unit Test File Body');
 		string error = FilePreviewController.postToRecordFeed('testfile.txt', EncodingUtil.base64Encode(testFile), test.Id);
        
        // No error
        System.assertEquals('', error);
        
        List<ContentDocumentLink> links = FilePreviewController.getAllDocumentLinks(test.Id);
        System.assertEquals(1, links.size());
        System.assertEquals('testfile.txt', links[0].ContentDocument.Title);
        
        
    }
}