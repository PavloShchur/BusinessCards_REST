global class SObjectWrapper implements Comparable {
    
    public sObject obj;
    
    public SObjectWrapper(sObject o) {
        obj = o;
    }
    
    global Integer compareTo(Object compareTo) {
        SObjectWrapper compareToContact = (SObjectWrapper)compareTo;
        
        Integer returnValue = 0;
        if ((Datetime)obj.get('CreatedDate') > (Datetime)compareToContact.obj.get('CreatedDate')) {
            returnValue = 1;
        } else if ((Datetime)obj.get('CreatedDate') < (Datetime)compareToContact.obj.get('CreatedDate')) {
            returnValue = -1;
        }
        
        return returnValue;       
    }
}