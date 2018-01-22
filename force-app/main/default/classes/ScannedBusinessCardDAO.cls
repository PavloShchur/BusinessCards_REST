public class ScannedBusinessCardDAO {
            
    public static List<Scanned_Business_Cards__c> getBusinessCardByCreatedByIdAndStatus(String userId, String status) {
        return [SELECT Created_By_Id__c,
                Account_Name__c,
                Full_Name__c, Status__c,
                Title__c
                FROM Scanned_Business_Cards__c
                WHERE Status__c = :status
                AND Created_By_Id__c = :userId];
            
    }
    
    public static List<Scanned_Business_Cards__c> getCardByCardId(String cardId) {
        return [SELECT Id, Salutation__c,
                First_Name__c, Last_Name__c,
                Account_Name__c,
                Title__c, Phone__c,
                Mobile__c, Fax__c, Email__c, 
                Website__c, Street1__c, Street2__c, 
                City__c, State_Country__c, Country__c, 
                Postcode__c, Notes__c, Created_By_Id__c,
                Status__c
                FROM Scanned_Business_Cards__c
                WHERE Id = :cardId];
        
    }
    
    public static List<Scanned_Business_Cards__c> getCard() {
        return new List<Scanned_Business_Cards__c>([SELECT Name, Account_Name__c,
                                                    Created_By_Id__c, First_Name__c, Last_Name__c,
                                                    Contact__c, Account__c
                                                    FROM Scanned_Business_Cards__c]);
    }
    
    public static List<Scanned_Business_Cards__c> getCardBySObjectName(Map<String, Id> sObjectName2sObjectId, Map<Schema.SObjectType, List<Scanned_Business_Cards__c>> cardsMapBeforeDelete){
        
        if(sObjectName2sObjectId.isEmpty()) return new List<Scanned_Business_Cards__c>();
        
        List<Scanned_Business_Cards__c> cards = new List<Scanned_Business_Cards__c>();
        
        if(sObjectName2sObjectId.values().get(0).getSobjectType() == Account.sObjectType) {
            if(cardsMapBeforeDelete.isEmpty()) {
                cards = [SELECT Account_Name__c FROM Scanned_Business_Cards__c WHERE Account_Name__c IN :sObjectName2sObjectId.keySet()];  
            } else {
                cards = [SELECT Account_Name__c FROM Scanned_Business_Cards__c WHERE Id IN :cardsMapBeforeDelete.get(sObjectName2sObjectId.values().get(0).getSobjectType())]; 
            }              
        } else if(sObjectName2sObjectId.values().get(0).getSobjectType() == Contact.sObjectType) {
           if(cardsMapBeforeDelete.isEmpty()) {
               cards = [SELECT Contact_Name__c FROM Scanned_Business_Cards__c WHERE Contact_Name__c IN :sObjectName2sObjectId.keySet()];
           } else {																											
               cards = [SELECT Contact_Name__c FROM Scanned_Business_Cards__c WHERE Id IN :cardsMapBeforeDelete.get(sObjectName2sObjectId.values().get(0).getSobjectType())];
           }              
        }
        return cards;
    }
    
    public static List<Scanned_Business_Cards__c> getCardBySObjectLookup(List<sObject> oldList){
        
        List<Scanned_Business_Cards__c> cards = new list<Scanned_Business_Cards__c>();
        
        if(oldList.get(0).getSobjectType() == Account.sObjectType){
           cards = [SELECT Account__c FROM Scanned_Business_Cards__c WHERE Account__c IN :oldList];
        }
        
        if(oldList.get(0).getSobjectType() == Contact.sObjectType){
           cards = [SELECT Contact__c FROM Scanned_Business_Cards__c WHERE Contact__c IN :oldList];
        }
        return cards;
    }

    public static List<Scanned_Business_Cards__c> getCard_DynamicSort(String sortFullExp) {
        List<Scanned_Business_Cards__c> sortedCards = new List<Scanned_Business_Cards__c>();
        
        for(Scanned_Business_Cards__c cardItem :Database.query('SELECT Name, Account_Name__c,' + 
                                                               ' Created_By_Id__c, First_Name__c, Last_Name__c,' + 
                                                               ' Contact__c, Account__c FROM Scanned_Business_Cards__c' +
                                                               ' ORDER BY ' +  sortFullExp + ' LIMIT 20')) {
        sortedCards.add(cardItem);
      }
        return sortedCards;
    }
    
    public static List<Scanned_Business_Cards__c> getCard_DynamicSearch(String searchString) {
        List<Scanned_Business_Cards__c> foundCards = new List<Scanned_Business_Cards__c>();
        
        for(Scanned_Business_Cards__c cardItem :Database.query('SELECT Name, Account_Name__c,' + 
                                                               ' Created_By_Id__c, First_Name__c, Last_Name__c,' + 
                                                               ' Contact__c, Account__c FROM Scanned_Business_Cards__c' +
                                                               ' WHERE  Account_Name__c LIKE \'%' 
                                                               + searchString + '%\' LIMIT 20')) {
          foundCards.add(cardItem);
        }
        return foundCards;
    }
    
    public static List<sObject> getSObject_BySObjectName(Schema.SObjectType sObjectType, Set<String> sObjectName) {
        List<sObject> sObjects = new List<sObject>();
        String query = ' WHERE Name IN :sObjectName ORDER BY CreatedDate DESC LIMIT 1';
        
        if(sObjectType == Account.sObjectType){
            sObjects = Database.query('SELECT Name FROM ' + sObjectType + query);
        } else if(sObjectType == Contact.sObjectType) {
            sObjects = Database.query('SELECT Name FROM ' + sObjectType + query);
        }
        
        return sObjects;
    }
    
}