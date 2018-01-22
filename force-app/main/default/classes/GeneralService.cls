public class GeneralService {
    
    public static Map<Schema.sObjectType, List<Scanned_Business_Cards__c>> cardsMapBeforeDelete 
        = new Map<Schema.sObjectType, List<Scanned_Business_Cards__c>>();
    
    private static final Map<Schema.SObjectType, Schema.sObjectField> sObjType2fieldNames
        = new Map<Schema.SObjectType, Schema.sObjectField>{
            Account.sObjectType => Scanned_Business_Cards__c.Account_Name__c,
                Contact.sObjectType => Scanned_Business_Cards__c.Contact_Name__c
    };
    
    private static final Map<Schema.SObjectType, List<Schema.sObjectField>> sObjType2fieldNames_2 
      = new Map<Schema.SObjectType, List<Schema.sObjectField>>{
           Account.sObjectType => new List<Schema.sObjectField>{Account.Name},
                Contact.sObjectType => new List<Schema.sObjectField>{Contact.FirstName, Contact.LastName} 
    };
    
    private static final Map<Schema.SObjectType, Schema.sObjectField> sObjType2sObjectLookup 
        = new Map<Schema.SObjectType, Schema.sObjectField>{
            Account.sObjectType => Scanned_Business_Cards__c.Account__c,
                Contact.sObjectType => Scanned_Business_Cards__c.Contact__c
    };
    
                    
    public static Map<Schema.sObjectType, List<sObject>> getSObjects(Map<Id, sObject> oldMap, List<sObject> newList){
                
    	Map<Schema.sObjectType, List<sObject>> sObjectType2sObjects = new Map<Schema.sObjectType, List<sObject>>();
                
        for(sObject sObjItem :(newList == null) ? oldMap.values() : newList){
            
            Schema.SObjectType sObjType = sObjItem.getSObjectType();
            
            if(sObjectType2sObjects.get( sObjType ) == null) sObjectType2sObjects.put( sObjType, new List<sObject>()); 
            
            for(Schema.sObjectField sObjField :sObjType2fieldNames_2.get( sObjType )){
                
                if( oldMap == null || ( newList != null && (oldMap.get(sObjItem.Id).get(sObjField) != sObjItem.get(sObjField)) )) {
                    if( oldMap != null ) sObjectType2sObjects.get( sObjType ).add(oldMap.get(sObjItem.Id));
                    sObjectType2sObjects.get( sObjType ).add( sObjItem );
                } else {
                    sObjectType2sObjects.get( sObjItem.getSObjectType() ).add(sObjItem);
                }
                
            }
        }
        return sObjectType2sObjects;
    }                
                    
    public static void populateSObjectIdOnCardGeneric(Map<Schema.SObjectType, List<sObject>> sObjects) {
        
        if(sObjects.isEmpty()) return;
        
        Map<String, Id> fullName2sObjectId = GeneralService.getUniqueSObjects(sObjects);
        
        Map<String, List<Id>> fullName2CardIds = new Map<String, List<Id>>(); 
        List<Scanned_Business_Cards__c> cardsToUpdate = new List<Scanned_Business_Cards__c>();
        
            for(Schema.SObjectType sObjectType :sObjects.keySet()){
                
                Schema.SObjectField sObjField = sObjType2fieldNames.get(sObjectType);
            
                for(Scanned_Business_Cards__c card :ScannedBusinessCardDAO.getCardBySObjectName(fullName2sObjectId, cardsMapBeforeDelete)) { 
                    if(fullName2CardIds.get((String)card.get( sObjField )) == null) {
                        fullName2CardIds.put((String)card.get( sObjField ), new List<Id>());
                    }
                    fullName2CardIds.get((String)card.get( sObjField )).add(card.Id);
                }

                if(fullName2CardIds.isEmpty()) continue;
                    
                    Map<String, Id> sObjectName2sObjecttId = new Map<String, Id>();
                    for(sObject contItem :ScannedBusinessCardDAO.getSObject_BySObjectName(sObjectType, fullName2CardIds.keySet())){
                        sObjectName2sObjecttId.put((String)contItem.get('Name'), contItem.Id);
                    }
                    
                    for(String fullName :fullName2sObjectId.keySet()) {
                        
                        if(fullName2CardIds.get(fullName) == null) continue;
                        
                        for(Id cardId :fullName2CardIds.get(fullName)){
                            Scanned_Business_Cards__c card = new Scanned_Business_Cards__c();
                            
                            card.Id = cardId;
                            card.put(sObjType2sObjectLookup.get(sObjectType), sObjectName2sObjecttId.get(fullName));
                            card.Status__c = Constants.STATUS_COMPLETE;
                           
                            cardsToUpdate.add(card); 
                        }
                    }
                    UPDATE ( cardsToUpdate ); 
            }
    }
    
    public static Boolean isValid(String stringValue, Schema.SObjectType sObjectType) {
        
        Id sObjectId;
        
        if(isId(stringValue)) { sObjectId = (Id)stringValue; }
        
        return isValid(sObjectId, sObjectType);
        
    }
    
    public static Boolean isValid(Id sObjectId, Schema.SObjectType sObjectType) { return !(sObjectId == null || sObjectId.getSObjectType() != sObjectType); }
    
    public static Boolean isId(String stringValue) { return stringValue instanceOf Id; }
    
    public static List<String> getValuesOfPicklist_ScannedBusinessCard () {
        
        List<String> myPicklist = new List<String>();
        
        Schema.DescribeFieldResult field = Scanned_Business_Cards__c.Status__c.getDescribe();
        
        for (Schema.PicklistEntry f :field.getPicklistValues()) {
            
            myPicklist.add( f.getLabel() );
            
        }
        
        return myPicklist;          
    }
    
    public static Boolean listContains(Object[] source, Object target) {   return (new Set<Object>(source)).contains(target); }
    
    public static String generateFullName(Schema.SObjectType objType, Scanned_Business_Cards__c card) {
        
        List<String> partialResult = new List<String>();
        partialResult.add((String)card.get(sObjType2fieldNames.get(objType)));

        return String.join(partialResult, ' ').trim();
    }
    
    public static String generateFullNameFromSObject(Schema.SObjectType objType, sObject obj) {
        
        List<String> partialResult = new List<String>();
        
        for(Schema.SObjectField fieldName :sObjType2fieldNames_2.get(objType)) {
            partialResult.add((String)obj.get(fieldName));
        }
        return String.join(partialResult, ' ').trim();
    }
    
    public static List<Sobject> removeDuplicates(List<SObject> originalList) {
        
        Set<sObject> myset = new Set<sObject>();
        List<sobject> result = new List<sobject>();
        
        for (sobject s : originalList) {
            if (myset.add(s)) {
                result.add(s);
            }
        }
        
        return result;
    }
    
    public static Map<String, Id> getUniqueSObjects(Map<Schema.SObjectType, List<sObject>> sObjects) {
        
        if(sObjects.isEmpty()) return new Map<String, Id>();
        
        SObjectWrapper[] sObjectList = new List<SObjectWrapper>();
        Map<String, Id> name2sObjectId = new Map<String, Id>();
        String fullName = '';
        
        for( Schema.SObjectType sObjType :sObjects.keySet() ) {
            for(sObject obj :sObjects.get( sobjType ) ) {
                fullName = GeneralService.generateFullNameFromSObject( sObjType, obj );
                sObjectList.add( new SObjectWrapper( obj ));               
            }
        }
        
        sObjectList.sort();
        
        for(Integer i = 0; i <sObjectList.size(); i++) {
            name2sObjectId.put(fullName, sObjectList[i].obj.Id);
        } 
        return name2sObjectId;
    }
    
    public static void getRelatedCards(List<sObject> oldList) {
                
        if(cardsMapBeforeDelete.get(oldList.get(0).getSobjectType()) == null) {
            cardsMapBeforeDelete.put(oldList.get(0).getSobjectType(), new List<Scanned_Business_Cards__c>());
        }
        cardsMapBeforeDelete.get(oldList.get(0).getSobjectType()).addAll(ScannedBusinessCardDAO.getCardBySObjectLookup(oldList));
    }
}