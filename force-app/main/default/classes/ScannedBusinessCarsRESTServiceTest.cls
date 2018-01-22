@isTest
private class ScannedBusinessCarsRESTServiceTest {
    
    @testSetup static void setup() {
        
        List<Scanned_Business_Cards__c> listOfCards = new List<Scanned_Business_Cards__c>();
        
        Account a = new Account(Name = 'AccountLastName');
        insert a;
        
        Contact c = new Contact(LastName = 'ContactLastName');
        insert c;
        
        for(Integer i = 0; i < 1000; i++) {
            
            listOfCards.add(
                new Scanned_Business_Cards__c(
                    Account_Name__c = 'MyCistomId_1',
                    Title__c = 'Title' + i,
                    Notes__c = 'Notes' + i,
                    Created_By_Id__c = '0050O000006eb3n',
                    Status__c = Constants.STATUS_COMPLETE
                  
                ));
            
            listOfCards.add(                
                
                new Scanned_Business_Cards__c(
                    Account_Name__c = 'MyCistomId_2',
                    Title__c = 'Title' + i,
                    Notes__c = 'Notes' + i,
                    Created_By_Id__c = '0050O000006eb3n',
                    Status__c = Constants.STATUS_INCOMPLETE
                ));
            
            listOfCards.add(                
                
                new Scanned_Business_Cards__c(
                    Account_Name__c = 'MyCistomId_1',
                    Title__c = 'Title' + i,
                    Notes__c = 'Notes' + i,
                    Created_By_Id__c = '0050O000006eXXX',
                    Status__c = Constants.STATUS_INCOMPLETE
                ));
            
        }
        
        insert listOfCards;
        
    }
    

    @isTest static void doGet_getCardsByCreatorId_StatusNotProvided() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.addParameter('creatorId', '0050O000006eb3n');
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.CardsList listOfCardsFromResponse = 
            (DTOScannedBusinessCard.CardsList) JSON.deserialize( res.responseBody.toString(), DTOScannedBusinessCard.CardsList.class );
        
        System.assertEquals(1000, listOfCardsFromResponse.cardItemList.size());
        
        List<Scanned_Business_Cards__c> listOfCardsFromSetup = [ SELECT Id, Status__c, Account_Name__c, Title__c, Full_Name__c 
                                                                FROM Scanned_Business_Cards__c 
                                                                WHERE Created_By_Id__c = '0050O000006eb3n' 
                                                                And Status__c = :Constants.STATUS_INCOMPLETE ];
        
        System.assertEquals(listOfCardsFromResponse.cardItemList.size(), listOfCardsFromSetup.size());
        
        for(Integer i = 0; i < listOfCardsFromResponse.cardItemList.size(); i++) {
            
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).status, listOfCardsFromSetup.get(i).Status__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).accountName, listOfCardsFromSetup.get(i).Account_Name__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).fullName, listOfCardsFromSetup.get(i).Full_Name__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).title, listOfCardsFromSetup.get(i).Title__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).Id, listOfCardsFromSetup.get(i).Id);
            
        }
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(true, res.responseBody.toString().contains(Constants.FIELD_STATUS));
        System.assertEquals(true, res.responseBody.toString().contains('Id'));
        System.assertEquals(true, res.responseBody.toString().contains('accountName'));
        System.assertEquals(true, res.responseBody.toString().contains('title'));
    }
    
    @isTest static void doGet_getCardsByCreatorId_StatusComplete() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('creatorId', '0050O000006eb3n');
        req.addParameter('status', Constants.STATUS_COMPLETE);
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.CardsList listOfCardsFromResponse = 
            (DTOScannedBusinessCard.CardsList) JSON.deserialize( res.responseBody.toString(), DTOScannedBusinessCard.CardsList.class );
        
        System.assertEquals(1000, listOfCardsFromResponse.cardItemList.size());
        
        List<Scanned_Business_Cards__c> listOfCardsFromSetup = [SELECT Id, Status__c, Account_Name__c, Title__c, Full_Name__c 
                                                                FROM Scanned_Business_Cards__c 
                                                                WHERE Created_By_Id__c = '0050O000006eb3n'
                                                                AND Status__c = :Constants.STATUS_COMPLETE];
        
        System.assertEquals(listOfCardsFromResponse.cardItemList.size(), listOfCardsFromSetup.size());
        
        for(Integer i = 0; i < listOfCardsFromResponse.cardItemList.size(); i++) {
            
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).status, listOfCardsFromSetup.get(i).Status__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).accountName, listOfCardsFromSetup.get(i).Account_Name__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).fullName, listOfCardsFromSetup.get(i).Full_Name__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).title, listOfCardsFromSetup.get(i).Title__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).Id, listOfCardsFromSetup.get(i).Id);
            
        }
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(true, res.responseBody.toString().contains('status'));
        System.assertEquals(true, res.responseBody.toString().contains(Constants.FIELD_ID));
        System.assertEquals(true, res.responseBody.toString().contains('accountName'));
        System.assertEquals(true, res.responseBody.toString().contains('title'));
        
    }
    
    
    @isTest static void doGet_getCardsByCreatorId_StatusIncomplete() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('creatorId', '0050O000006eb3n');
        req.addParameter('status', Constants.STATUS_INCOMPLETE);
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.CardsList listOfCardsFromResponse = 
            (DTOScannedBusinessCard.CardsList) JSON.deserialize( res.responseBody.toString(), DTOScannedBusinessCard.CardsList.class );
        
        System.assertEquals(1000, listOfCardsFromResponse.cardItemList.size()); 
        
        List<Scanned_Business_Cards__c> listOfCardsFromSetup = [SELECT Id, Status__c, Account_Name__c, Title__c, Full_Name__c 
                                                                FROM Scanned_Business_Cards__c 
                                                                WHERE Created_By_Id__c = '0050O000006eb3n'
                                                                AND Status__c = :Constants.STATUS_INCOMPLETE];
        
        System.assertEquals(listOfCardsFromResponse.cardItemList.size(), listOfCardsFromSetup.size());
        
        for(Integer i = 0; i < listOfCardsFromResponse.cardItemList.size(); i++) {
            
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).status, listOfCardsFromSetup.get(i).Status__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).accountName, listOfCardsFromSetup.get(i).Account_Name__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).fullName, listOfCardsFromSetup.get(i).Full_Name__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).title, listOfCardsFromSetup.get(i).Title__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).Id, listOfCardsFromSetup.get(i).Id);
            
        }
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(true, res.responseBody.toString().contains('status'));
        System.assertEquals(true, res.responseBody.toString().contains('Id'));
        System.assertEquals(true, res.responseBody.toString().contains('accountName'));
        System.assertEquals(true, res.responseBody.toString().contains('title'));
        
    } 
    
    @isTest static void doGet_getCardsByCreatorId_NoUserFound() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
     
        req.addParameter('creatorId', '0050O000007eb3o');
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(false, res.responseBody.toString().contains('status'));
        System.assertEquals(true, res.responseBody.toString().contains('Id'));
        System.assertEquals(false, res.responseBody.toString().contains('accountName'));
        System.assertEquals(false, res.responseBody.toString().contains('title'));
        
        DTOScannedBusinessCard.StatusMessage messageResponse =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('By Id of the User, which you specified, were not found any business cards or this User does not exist.', 
                            messageResponse.message);
        
    } 
    
     @isTest static void doGet_getCardsByCreatorIdAndStatus_NoUserFound() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
     
        req.addParameter('creatorId', '0050O000007eb3o');
        req.addParameter('status', Constants.STATUS_COMPLETE);
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(false, res.responseBody.toString().contains('status'));
        System.assertEquals(true, res.responseBody.toString().contains('Id'));
        System.assertEquals(false, res.responseBody.toString().contains('accountName'));
        System.assertEquals(false, res.responseBody.toString().contains('title'));
        
        DTOScannedBusinessCard.StatusMessage messageResponse =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('By Id of the User, which you specified, were not found any business cards or this User does not exist.', 
                            messageResponse.message);
        
    }
    
        @isTest static void doGet_getCardsByCreatorId_NoBusinessCardFound() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
     
        req.addParameter('creatorId', '0050O000006f26o');
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage responseMessage =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
            
        System.assertEquals(
            'By Id of the User, which you specified, were not found any business cards or this User does not exist.', 
                            responseMessage.message);
         
    }
    
    @isTest static void doGet_getCardsByCreatorId_InvalidStatus() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.addParameter('creatorId', '0050O000006eb3n'); 
        req.addParameter('status', 'Finished'); 
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        String testBlob = res.responseBody.toString();
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(true, testBlob.contains('status'));
        System.assertEquals(false, testBlob.contains('Id'));
        System.assertEquals(false, testBlob.contains('accountName'));
        System.assertEquals(false, testBlob.contains('title'));
        
        DTOScannedBusinessCard.StatusMessage statusMesaage = 
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize( res.responseBody.toString(), 
                                                                    DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. Please check the status. ' + 
                            'Maybe you entered the status which does not exist. After that again.', 
                            statusMesaage.message);
        
        System.assertEquals(Constants.HTTP_STATUS_NOT_FOUND, statusMesaage.errorCode);
        
    } 
    
    
    @isTest static void doGet_getCardsByCardId() {
        
        List<Scanned_Business_Cards__c> listOfCardsFromSetup = [SELECT Id, Salutation__c,
                                                                First_Name__c, Last_Name__c,
                                                                Account_Name__c,
                                                                Title__c, Phone__c,
                                                                Mobile__c, Fax__c, Email__c, 
                                                                Website__c, Street1__c, Street2__c, 
                                                                City__c, State_Country__c, Country__c, 
                                                                Postcode__c, Notes__c, Created_By_Id__c,
                                                                Status__c
                                                                FROM Scanned_Business_Cards__c
                                                                WHERE Account_Name__c = 'MyCistomId_1'
                                                                AND Title__c = 'Title0'
                                                                LIMIT 1];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
   
        req.addParameter('id', listOfCardsFromSetup.get(0).Id);
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.CardItemListFull listOfCardsFromResponse = 
            (DTOScannedBusinessCard.CardItemListFull) JSON.deserialize( 
                res.responseBody.toString(), DTOScannedBusinessCard.CardItemListFull.class );
        
        System.assertEquals(1, listOfCardsFromResponse.cardItemList.size());
        System.assertEquals(listOfCardsFromResponse.cardItemList.size(), listOfCardsFromSetup.size());
        
        for(Integer i = 0; i < listOfCardsFromResponse.cardItemList.size(); i++) {
            
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).salutation, listOfCardsFromSetup.get(i).Salutation__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).lastName, listOfCardsFromSetup.get(i).Last_Name__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).phone, listOfCardsFromSetup.get(i).Phone__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).mobile, listOfCardsFromSetup.get(i).Mobile__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).fax, listOfCardsFromSetup.get(i).Fax__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).email, listOfCardsFromSetup.get(i).Email__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).website, listOfCardsFromSetup.get(i).Website__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).street1, listOfCardsFromSetup.get(i).Street1__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).street2, listOfCardsFromSetup.get(i).Street2__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).city, listOfCardsFromSetup.get(i).City__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).stateCountry, listOfCardsFromSetup.get(i).State_Country__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).country, listOfCardsFromSetup.get(i).Country__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).postcode, listOfCardsFromSetup.get(i).Postcode__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).notes, listOfCardsFromSetup.get(i).Notes__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).createdById, listOfCardsFromSetup.get(i).Created_By_Id__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).status, listOfCardsFromSetup.get(i).Status__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).accountName, listOfCardsFromSetup.get(i).Account_Name__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).title, listOfCardsFromSetup.get(i).Title__c);
            System.assertEquals(listOfCardsFromResponse.cardItemList.get(i).cardId, listOfCardsFromSetup.get(i).Id);           
            
        }    
        
    }
    
    @isTest static void doGet_getCardsByCardId_NoCardFound() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
    
        req.addParameter('id', 'a000O00000s34vg');
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage messageResponse =
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize(
                res.responseBody.toString(), DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('By Id of the Card, which you specified, were not found any business card.', 
                            messageResponse.message);
        
    }   
    
    @isTest static void doGet_getCardsByCardId_InvalidCardId() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
   
        req.addParameter('id', 'a000O00000s3XX');
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        String testBlob = res.responseBody.toString();
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(false, testBlob.contains('status'));
        System.assertEquals(true, testBlob.contains('Id'));
        System.assertEquals(false, testBlob.contains('accountName'));
        System.assertEquals(false, testBlob.contains('title'));
        
        DTOScannedBusinessCard.StatusMessage responseMessage = 
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize( res.responseBody.toString(), 
                                                                    DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. ' + 
                    'Make sure that you specified the correct card Id', 
                            responseMessage.message);        
        
        System.assertEquals(Constants.HTTP_STATUS_NOT_FOUND, responseMessage.errorCode);
    
    }
    
    @isTest static void doGet_getCards_NoSuchUserId_And_Status() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.addParameter('creatorId', '0050O000006eXXn'); 
        req.addParameter('status', 'Uncomplete'); 
                
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        String testBlob = res.responseBody.toString();
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(true, testBlob.contains('status'));
        System.assertEquals(false, testBlob.contains('Id'));
        System.assertEquals(false, testBlob.contains('accountName'));
        System.assertEquals(false, testBlob.contains('title'));
        
        DTOScannedBusinessCard.StatusMessage statusMesaage = 
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize( res.responseBody.toString(), 
                                                                    DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. Please check the status. ' + 
                            'Maybe you entered the status which does not exist. After that again.', 
                            statusMesaage.message);
        
        System.assertEquals(Constants.HTTP_STATUS_NOT_FOUND, statusMesaage.errorCode);
        
    } 
    
    @isTest static void doGet_getCards_GenerateException_WithoutParameters() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
         
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doGet();
        
        Test.stopTest();
        
        String testBlob = res.responseBody.toString();
        
        System.assertNotEquals(null, res.responseBody.toString());
        System.assertEquals(false, testBlob.contains('status'));
        System.assertEquals(false, testBlob.contains('Id'));
        System.assertEquals(false, testBlob.contains('accountName'));
        System.assertEquals(false, testBlob.contains('title'));
        
        DTOScannedBusinessCard.StatusMessage statusMessage = 
            (DTOScannedBusinessCard.StatusMessage) JSON.deserialize( res.responseBody.toString(), 
                                                                    DTOScannedBusinessCard.StatusMessage.class );
        
        System.assertEquals('Your request is invalid. Please check the URL and method. Also make sure that you entered required parameters.' + 
                            'After that train again.', 
                            statusMessage.message);
        
        System.assertEquals(Constants.HTTP_STATUS_NOT_FOUND, statusMessage.errorCode);
        
    } 
    
    @isTest static void doPost_CreateCard_WithFewFields() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
         
        String requestBody = 
            '{ "firstName": "Test", "lastName": "Test LastName", "email": "testuser2@acorp.com", "createdById" : "0050O000006eb3n" }';
        
        req.requestBody = Blob.valueOf(requestBody);  
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doPost();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.CardItemListFull responseList = 
            (DTOScannedBusinessCard.CardItemListFull) JSON.deserialize( res.responseBody.toString(), 
                                                                       DTOScannedBusinessCard.CardItemListFull.class );
        
        for(Integer i = 0; i < responseList.cardItemList.size(); i++) {
            
            System.assertEquals('Test', responseList.cardItemList.get(i).firstName);
            System.assertEquals('Test LastName', responseList.cardItemList.get(i).lastName);
            
        }
        
    }
    
    @isTest static void doPost_CreateCard_WithAllFields() {
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
           
        String requestBody = 
            '{ "firstName": "Test", "lastName": "Test LastName", "email": "testuser2@acorp.com", "createdById" : "0050O000006eb3n",'
            + '"salutation" : "someSalutation", "title" : "someTitle", "phone" : "somePhone", "mobile" : "someMobile", "fax" : "someFax",' + 
            '"website" : "someWebsite", "street1" : "someStreet1", "street2" : "someStreet2", "city" : "someCity",' + 
            '"stateCountry" : "someStateCountry", "country" : "someCountry", "postcode" : "somePostcode", "notes" : "someNotes" }';
        
        req.requestBody = Blob.valueOf(requestBody);  
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doPost();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.CardItemListFull responseList = 
            (DTOScannedBusinessCard.CardItemListFull) JSON.deserialize( res.responseBody.toString(), 
                                                                       DTOScannedBusinessCard.CardItemListFull.class );
        
        for(Integer i = 0; i < responseList.cardItemList.size(); i++) {
            
            System.assertEquals('Test', responseList.cardItemList.get(i).firstName);
            System.assertEquals('Test LastName', responseList.cardItemList.get(i).lastName);
            System.assertEquals('testuser2@acorp.com', responseList.cardItemList.get(i).email);
            System.assertEquals('0050O000006eb3n', responseList.cardItemList.get(i).createdById);
            System.assertEquals('someSalutation', responseList.cardItemList.get(i).salutation);
            System.assertEquals('someTitle', responseList.cardItemList.get(i).title);
            System.assertEquals('somePhone', responseList.cardItemList.get(i).phone);
            System.assertEquals('someMobile', responseList.cardItemList.get(i).mobile);
            System.assertEquals('someFax', responseList.cardItemList.get(i).fax);
            System.assertEquals('someWebsite', responseList.cardItemList.get(i).website);
            System.assertEquals('someStreet1', responseList.cardItemList.get(i).street1);
            System.assertEquals('someStreet2', responseList.cardItemList.get(i).street2);
            System.assertEquals('someCity', responseList.cardItemList.get(i).city);
            System.assertEquals('someStateCountry', responseList.cardItemList.get(i).stateCountry);
            System.assertEquals('someCountry', responseList.cardItemList.get(i).country);
            System.assertEquals('somePostcode', responseList.cardItemList.get(i).postcode);
            System.assertEquals('someNotes', responseList.cardItemList.get(i).notes);
            
        }
        
    }
    
    @isTest static void doPost_UpdateCard_WithFewFields() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Created_By_Id__c,
                                                   First_Name__c,
                                                   Last_Name__c,
                                                   Account_Name__c,
                                                   Status__c,
                                                   Title__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCistomId_1'
                                                   AND Title__c = 'Title0'
                                                   LIMIT 1];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();       
        
        String requestBodyToUpdate = '{ "firstName": "Test Updated", "lastName": "Updated LastName", "email": "testuser2@acorp.com",' + 
            ' "createdById" : "0050O000006eb3n", "cardId" : "' + cardFromSetup.Id + '"}';
        
        req.requestBody = Blob.valueOf(requestBodyToUpdate);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doPost();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.CardItemListFull myListUpdated = 
            ( DTOScannedBusinessCard.CardItemListFull) JSON.deserialize( res.responseBody.toString(), 
                                                                        DTOScannedBusinessCard.CardItemListFull.class );
        for(Integer i = 0; i < myListUpdated.cardItemList.size(); i++) {
            
            System.assertEquals(cardFromSetup.Created_By_Id__c, myListUpdated.cardItemList.get(i).createdById);
            System.assertEquals(cardFromSetup.Account_Name__c, myListUpdated.cardItemList.get(i).accountName);
            System.assertEquals(cardFromSetup.Status__c, myListUpdated.cardItemList.get(i).status);
            System.assertEquals(cardFromSetup.Title__c, myListUpdated.cardItemList.get(i).title);
            System.assertNotEquals(cardFromSetup.First_Name__c, myListUpdated.cardItemList.get(i).firstName);
            System.assertNotEquals(cardFromSetup.Last_Name__c, myListUpdated.cardItemList.get(i).lastName);
            
            System.assertEquals('Test Updated', myListUpdated.cardItemList.get(i).firstName);
            System.assertEquals('Updated LastName', myListUpdated.cardItemList.get(i).lastName);
            System.assertEquals('testuser2@acorp.com', myListUpdated.cardItemList.get(i).email);
            System.assertEquals('0050O000006eb3n', myListUpdated.cardItemList.get(i).createdById);
            
            System.assertEquals(cardFromSetup.Id, myListUpdated.cardItemList.get(i).cardId);
        }
        
    }
    
    @isTest static void doPost_UpdateCard_WithAllFields() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Created_By_Id__c,
                                                   First_Name__c,
                                                   Last_Name__c,
                                                   Account_Name__c,
                                                   Status__c,
                                                   Title__c
                                                   FROM Scanned_Business_Cards__c
                                                   WHERE Account_Name__c = 'MyCistomId_1'
                                                   AND Title__c = 'Title0'
                                                   LIMIT 1];
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();    
        
        String requestBodyToUpdate = '{ "firstName": "Test Updated", "lastName": "Updated LastName", "email": "testuser2@acorp.com",' + 
            ' "createdById" : "0050O000006eb3n", "cardId" : "' + cardFromSetup.Id + '", ' + 
            '"street1" : "someStreet1", "street2" : "someStreet2", "city" : "someCity",' + 
            '"stateCountry" : "someStateCountry", "country" : "someCountry", "postcode" : "somePostcode", "notes" : "someNotes" }';
            
        req.requestBody = Blob.valueOf(requestBodyToUpdate);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doPost();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.CardItemListFull myListUpdated = 
            ( DTOScannedBusinessCard.CardItemListFull) JSON.deserialize( res.responseBody.toString(), 
                                                                        DTOScannedBusinessCard.CardItemListFull.class );
        
        for(Integer i = 0; i < myListUpdated.cardItemList.size(); i++) {
            
            System.assertEquals('Test Updated', myListUpdated.cardItemList.get(i).firstName);
            System.assertEquals('Updated LastName', myListUpdated.cardItemList.get(i).lastName);
            System.assertEquals('testuser2@acorp.com', myListUpdated.cardItemList.get(i).email);
            System.assertEquals('someCountry', myListUpdated.cardItemList.get(i).country);
            
        }
        
    }
    
        @isTest static void doPost_UpdateCard_InvalidCardId() {
                
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();       
        
        String requestBodyToUpdate = '{ "firstName": "Test Updated", "lastName": "Updated LastName", "email": "testuser2@acorp.com",' + 
            ' "createdById" : "0050O000006eb3n", "cardId" : "a000O00000s32"}';
                    
        req.requestBody = Blob.valueOf(requestBodyToUpdate);
        
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        
        ScannedBusinessCardRESTResource.doPost();
        
        Test.stopTest();
        
        DTOScannedBusinessCard.StatusMessage responseMessage =
            ( DTOScannedBusinessCard.StatusMessage) JSON.deserialize( res.responseBody.toString(),
                                                                        DTOScannedBusinessCard.StatusMessage.class );
        System.assertEquals(
            'Your request is invalid. Make sure that you specified the correct card Id. After that try again.', 
                            responseMessage.message);
        
    }
    
}