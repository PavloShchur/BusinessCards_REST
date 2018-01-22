@isTest
public class ImageRESTServiceTest {
    
    @testSetup static void setup() {
        
        List<Scanned_Business_Cards__c> listOfCards = new List<Scanned_Business_Cards__c>();       
        
        Scanned_Business_Cards__c card_1 = new Scanned_Business_Cards__c(
            Account_Name__c = 'MyCustomId_1',
            Last_Name__c = 'lastName',
            Title__c = 'Title0',
            Notes__c = 'Notes0',
            Created_By_Id__c = '0050O000006eb3n'
        );
        
        Scanned_Business_Cards__c card_2 = new Scanned_Business_Cards__c(
            
            Account_Name__c = 'MyCustomId_2',
            Last_Name__c = 'lastName',
            Title__c = 'Title1',
            Notes__c = 'Notes2',
            Created_By_Id__c = '0050O000006eb3n'
        );           
        
        insert new List<Scanned_Business_Cards__c> { card_1, card_2 };
                    
    }
    
    
    
    
    @isTest static void  doGet_RetrieveImage() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Id, Last_Name__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCustomId_1'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE );
        
        req.addParameter('id', cardFromSetup.Id);
        
        req.addParameter('Content-Type', 'image/png');
        
        RestContext.request = req;
        RestContext.response = res;
        
        ImageRESTResource.attachPicture();
        
        req.requestURI = 
            'http://waderest-developer-edition.eu9.force.com/services/apexrest/image';
        
        req.addParameter('id', cardFromSetup.Id);
               
        Test.startTest();
        
        ImageRESTResource.getAttachedPicture(); 
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage statusMessage =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assert(cardFromSetup.Id == statusMessage
                      .message
                      .split(':')
                      .get(1)
                      .replaceAll('\\)', '').trim());
    }
    
    @isTest static void  doGet_RetrieveImage_CardWithoutImage() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Id, Last_Name__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCustomId_1'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.addParameter('id', cardFromSetup.Id);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ImageRESTResource.getAttachedPicture(); 
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage statusMessage =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals(
            'By Id, which you specified, we coud not find any attachment', 
            statusMessage.message);
    }
    
    @isTest static void  doGet_RetrieveImage_InvalidCardId() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Id, Last_Name__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCustomId_1'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
       
        req.addParameter('id', 'a000O00000s32');
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ImageRESTResource.getAttachedPicture();
        
        Test.stopTest();            
        
        DTOScannedBusinessCard.StatusMessage statusMessage = 
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize( 
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. ' + 
                            'Make sure that you specified the correct card Id. And try again.', statusMessage.message);
        
        System.assertEquals(Constants.HTTP_STATUS_NOT_FOUND, statusMessage.errorCode);
    }
    
    @isTest static void  doGet_RetrieveImage_NULLId() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Id, Last_Name__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCustomId_1'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
                
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE );
        req.addParameter('id', cardFromSetup.Id);
        req.addParameter('Content-Type', 'image/png');
        
        RestContext.request = req;
        RestContext.response = res;
        
        ImageRESTResource.attachPicture();
        
        req.addParameter('id', NULL);
                
        Test.startTest();
        
        ImageRESTResource.getAttachedPicture(); 
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage statusMessage =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('The Id, which you specified, equals to NULL. Please, check the URL.', 
                            statusMessage.message);
        
    }
    
    @isTest static void doPost_CreateImage() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Id, Last_Name__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCustomId_1'
                                                   AND Title__c = 'Title0'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('id', cardFromSetup.Id);
        
        req.addParameter('Content-Type', 'image/png');
                
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE );
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ImageRESTResource.attachPicture();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage statusMessage =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals(cardFromSetup.Id, statusMessage
                            .message
                            .split(':')
                            .get(1)
                            .replaceAll('\\)', '').trim());
        
        
        System.assertEquals(cardFromSetup.Last_Name__c, statusMessage
                            .message
                            .split('with')
                            .get(1)
                            .split('\\(').get(0).trim());
    }
    
    @isTest static void doPost_CreateImage_WithoutCardId() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE );
        
        RestContext.request = req;
        RestContext.response = res;
        
        ImageRESTResource.attachPicture();
        
        DTOScannedBusinessCard.StatusMessage responseMessage =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. ' + 
                            'Please check the URL and whether you specified card Id. After that try again.', 
                            responseMessage.message );
    }
    
    @isTest static void doPost_CreateImage_WithoutContentType() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Id, Last_Name__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCustomId_1'
                                                   AND Title__c = 'Title0'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('id', cardFromSetup.Id);
                
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE );
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ImageRESTResource.attachPicture();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage statusMessage =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. ' + 
                            'Please check whether you specified the Content-Type. After that try again.', 
                            statusMessage.message);
    }
    
    @isTest static void doPost_CreateImage_InvalidCardId() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('id', 'a000O00000s32Z');
        
        req.addParameter('Content-Type', 'image/png');
                
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE );
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ImageRESTResource.attachPicture();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage statusMessage = 
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize( 
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. ' + 
                            'Make sure that you specified the card Id. And try again.', statusMessage.message);
        
        System.assertEquals(Constants.HTTP_STATUS_NOT_FOUND, statusMessage.errorCode);
    }
    
    
    @isTest static void doPost_CreateImage_GenerateException_ThisIsNotCardId() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('id', '0010O000006eb3n');
        
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE );
        
        RestContext.request = req;
        RestContext.response = res;
        
        ImageRESTResource.attachPicture();
        
        DTOScannedBusinessCard.StatusMessage responseMessage = 
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize( 
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. ' + 
                            'Make sure that you specified the card Id. And try again.', 
                            responseMessage.message );  
        
        System.assertEquals(Constants.HTTP_STATUS_NOT_FOUND, responseMessage.errorCode);
    }
    
    @isTest static void doPost_UpdateCardImage() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Id, Last_Name__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCustomId_1'
                                                   AND Title__c = 'Title0'];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.addParameter('id', cardFromSetup.Id);
                
        req.addParameter('Content-Type', 'image/png');
        
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE );
        
        RestContext.request = req;
        RestContext.response = res;
        
        ImageRESTResource.attachPicture();
 
        req.addParameter('id', cardFromSetup.Id);
                
        req.addParameter('Content-Type', 'image/png');
        
        req.requestBody = EncodingUtil.base64Decode( Constants.IMAGE_2 );
        
        Test.startTest();
        
        ImageRESTResource.attachPicture();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage statusMessage =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
                
        System.assertEquals(cardFromSetup.Id, statusMessage
                            .message
                            .split(':')
                            .get(1)
                            .replaceAll('\\)', '').trim());
    }
}