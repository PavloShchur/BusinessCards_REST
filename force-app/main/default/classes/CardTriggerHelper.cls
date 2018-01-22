public class CardTriggerHelper {

    private static final  Map<Schema.sObjectType, Schema.sObjectField> sObjectType2Field = new Map<Schema.sObjectType, Schema.sObjectField>{
        Account.sObjectType => Scanned_Business_Cards__c.Account__c, 
        Contact.sObjectType => Scanned_Business_Cards__c.Contact__c
    };
            
    public static Map<Schema.sObjectType, List<Scanned_Business_Cards__c>> getCardsForAccountLookup(
        Map<Id, Scanned_Business_Cards__c> oldMap, 
        List<Scanned_Business_Cards__c> newList 
    ){
        
        Map<Schema.sObjectType, List<Scanned_Business_Cards__c>> cards = new Map<Schema.sObjectType, List<Scanned_Business_Cards__c>>();
        cards.put(Account.sObjectType, new List<Scanned_Business_Cards__c>());
        
        if(oldMap == null) {
            for ( Scanned_Business_Cards__c cardNew :newList ){
                if (cardNew.Account_Name__c != null) {
                    cards.get(Account.sObjectType).add(cardNew);  
                }
            }
        }
        
        else if (oldMap != null && newList != null){
            for ( Scanned_Business_Cards__c cardNew : newList ){
                Scanned_Business_Cards__c cardOld = oldMap.get(cardNew.Id);
                if ( cardNew.Account_Name__c != cardOld.Account_Name__c  || cardNew.Account__c == null) {
                    cards.get(Account.sObjectType).add(cardNew);
                }
            }
        }  
        
        return cards;
        
    }
    
    public static Map<Schema.SObjectType, List<Scanned_Business_Cards__c>> getCardsForContactLookup( 
        Map<Id, Scanned_Business_Cards__c> oldMap, 
        List<Scanned_Business_Cards__c> newList 
    ){
        
        Map<Schema.SObjectType, List<Scanned_Business_Cards__c>> cards = new Map<Schema.SObjectType, List<Scanned_Business_Cards__c>>();
        cards.put(Contact.sObjectType, new List<Scanned_Business_Cards__c>());
        
        if(oldMap == null) {
            for ( Scanned_Business_Cards__c cardNew : newList ){
                if (cardNew.First_Name__c != null || cardNew.Last_Name__c != null) {
                    cards.get(Contact.sObjectType).add( cardNew );
                }
            }
        }
        
        else if (oldMap != null && newList != null){
            for ( Scanned_Business_Cards__c cardNew : newList ){
                Scanned_Business_Cards__c cardOld = oldMap.get(cardNew.Id);
                if (cardNew.First_Name__c != cardOld.First_Name__c || cardNew.Last_Name__c != cardOld.Last_Name__c) {
                    cards.get(Contact.sObjectType).add( cardNew );
                }                    
            }
        }
        return cards;
    }     
    
    
    public static void populateLookup(Map<Schema.SObjectType, List<Scanned_Business_Cards__c>> cards) {
        if (cards.isEmpty()) return;
        
        Map<String, List<Scanned_Business_Cards__c>> fullName2Cards = new Map<String, List<Scanned_Business_Cards__c>>();
        
        for( Schema.SObjectType sObjType :cards.keySet() ) {
            
            for( Scanned_Business_Cards__c cardItem :cards.get( sobjType ) ) {
                
                String fullName = GeneralService.generateFullName( sobjType, cardItem );
                
                if( ! fullName2Cards.containsKey(fullName) ) {
                    fullName2Cards.put(fullName, new List<Scanned_Business_Cards__c>());   
                }
                
                fullName2Cards.get( fullName ).add( cardItem );
            }
            
        Set<String> fullNames = fullName2Cards.keySet();
            
        Map<String, Id> name2recordId = new  Map<String, Id>();
            
        for(sObject objItem :getSObjectsByName(sObjType, fullNames)){                          
            String name = (String)objItem.get('Name');
            if( ! name2recordId.containsKey( name ) ){
                name2recordId.put( name, (Id) objItem.get('Id') );
            }
            }
            
        for(String key :fullName2Cards.keySet()) {
            for(Scanned_Business_Cards__c card :fullName2Cards.get(key)){
                
                card.put(sObjectType2Field.get(sObjType), name2recordId.get(key));
                
                if(name2recordId.get(key) != null) card.Status__c = Constants.STATUS_COMPLETE;
                
            }
        }
            
        } 
    }
       
    private static List<sObject> getSObjectsByName(Schema.sObjectType sObjectType, Set<String> fullNames) {
        return Database.query('SELECT Name FROM ' + sObjectType.getDescribe().getName() + ' WHERE Name IN:fullNames ORDER BY CreatedDate DESC');
    }

}