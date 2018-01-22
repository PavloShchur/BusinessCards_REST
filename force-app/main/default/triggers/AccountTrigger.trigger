trigger AccountTrigger on Account (after insert, after update, before delete, after delete) {
    
    if(Trigger.isBefore) {
        if(Trigger.isDelete) {
            GeneralService.getRelatedCards(Trigger.old);    
        }
    }
    
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isDelete) {
            GeneralService.populateSObjectIdOnCardGeneric(
                GeneralService.getSObjects(Trigger.oldMap, Trigger.new));
        }
    }
    
}