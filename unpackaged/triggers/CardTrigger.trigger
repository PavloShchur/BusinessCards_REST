trigger CardTrigger on Scanned_Business_Cards__c (before insert, before update) {
    
    if(Trigger.isBefore){
        
        if(Trigger.isUpdate || Trigger.isInsert) {
            
            CardTriggerHelper.populateLookup(
                CardTriggerHelper.getCardsForAccountLookup(Trigger.oldMap, Trigger.new));
            
            CardTriggerHelper.populateLookup(
                CardTriggerHelper.getCardsForContactLookup(Trigger.oldMap, Trigger.new));
            
        }
    }
}