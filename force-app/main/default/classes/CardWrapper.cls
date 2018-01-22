global class CardWrapper implements Comparable {
    
    public Scanned_Business_Cards__c card;
    
    public CardWrapper(Scanned_Business_Cards__c c) {
        card = c;
    }
    
    global Integer compareTo(Object compareTo) {
        CardWrapper compareToCard = (CardWrapper)compareTo;
        
        Integer returnValue = 0;
        if (card.Created_By_Id__c > compareToCard.card.Created_By_Id__c) {
            returnValue = 1;
        } else if (card.Created_By_Id__c < compareToCard.card.Created_By_Id__c) {
            returnValue = -1;
        }
        
        return returnValue;       
    }
}