@isTest
public class CardTriggerHelperTest {
    
    @testSetup static void setup() {
        
        List<Scanned_Business_Cards__c> listOfCards = new List<Scanned_Business_Cards__c>();
        List<Account> accounts = new List<Account>();
        List<Account> checkCreatedDate = new List<Account>();
        List<Contact> contacts = new List<Contact>();
        List<Contact> checkCreatedDateContact = new List<Contact>();
        
        insert new Account(Name = 'singleAccount');
        insert new Contact(FirstName = 'singleContact', LastName = 'singleContact');        
        
        for(Integer i = 0; i < 100; i++) {
            
            listOfCards.add(
                
                new Scanned_Business_Cards__c(
                    
                    Account_Name__c = 'accountName' + i,
                    First_Name__c = 'firstName' + i,
                    Last_Name__c = 'lastName' + i,
                    Title__c = 'Title' + i,
                    Notes__c = 'Notes' + i,
                    Created_By_Id__c = '0050O000006eb3n',
                    Status__c = 'Complete'
                    
                )
            );            
        }
        
        insert listOfCards;
        
        for(Integer i = 0; i < 100; i++) {
            
            accounts.add(
                new Account(                    
                    Name = 'accountName' + i                   
                ));            
        }
        
        insert accounts;
        
        for(Integer i = 0; i < 100; i++) {
            
            checkCreatedDate.add(
                new Account(                    
                    Name = 'accountName'                   
                ));            
        }
        
        insert checkCreatedDate;
        
        for(Integer i = 0; i < 100; i++) {
            
            contacts.add(
                new Contact(                    
                    FirstName = 'firstName' + i, 
                    LastName = 'lastName' + i                   
                )
            );            
        }
        
        insert contacts;
        
        for(Integer i = 0; i < 100; i++) {
            
            checkCreatedDateContact.add(
                new Contact(                    
                    FirstName = 'contactName', 
                    LastName = 'contactLastName'                   
                )
            );            
        }
        
        insert checkCreatedDateContact;        
    }
    
    @isTest static void createCard_AccountLookupIsPopulated() {
        
        insert new Account(Name = 'testAccount_1');
        
        insert new Scanned_Business_Cards__c(Account_Name__c = 'testAccount_1', Created_By_Id__c = 'testAccount_1');
        
        System.assertEquals([SELECT Account__c FROM Scanned_Business_Cards__c WHERE Account_Name__c = 'testAccount_1' 
                             AND Created_By_Id__c = 'testAccount_1'].Account__c, 
                            [SELECT Id FROM Account WHERE Name = 'testAccount_1'].Id);  
    }
    
    @isTest static void accountNameIsChanged_MultipleAccountsFound_AccountLookupIsPopulated() {
        
        insert new Account(Name = 'accountNameDelay');
        ContactTestUtilities.sleep(2000);
        insert new Account(Name = 'accountNameDelay');
        ContactTestUtilities.sleep(2000);
        insert new Account(Name = 'accountNameDelay', Website = 'theYoungest');          
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Account_Name__c, Account__c 
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE Account_Name__c = 'accountName0'];
        
        cardFromSetup.Account_Name__c = 'accountNameDelay';
        
        Test.startTest();
        update cardFromSetup;
        Test.stopTest();
        
        System.debug([SELECT CreatedDate, Website FROM Account 
                      WHERE Name = 'accountNameDelay' 
                      ORDER BY CreatedDate DESC]);
        
        System.assertEquals([SELECT Account__c 
                             FROM Scanned_Business_Cards__c 
                             WHERE Account_Name__c = 'accountNameDelay'].Account__c, [SELECT Id FROM Account 
                                                                                   WHERE Name = 'accountNameDelay' 
                                                                                   AND Website = 'theYoungest'].Id);
    }
    
    @isTest static void accountNameIsChanged_AccountLookupIsPopulated() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Account_Name__c, Account__c 
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE Account_Name__c = 'accountName0'];
        
        cardFromSetup.Account_Name__c = 'singleAccount';
        
        Test.startTest();
        update cardFromSetup;
        Test.stopTest();
        
        System.assertEquals([SELECT Account__c 
                             FROM Scanned_Business_Cards__c 
                             WHERE Account_Name__c = 'singleAccount'].Account__c, [SELECT Name FROM Account
                                    												WHERE Name = 'singleAccount'].Id);
        
    }
    
    @isTest static void accountNameIsChanged_NoneAccountFound() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Account_Name__c, Account__c 
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE Account_Name__c = 'accountName0'];
        
        cardFromSetup.Account_Name__c = 'noMatchingAccount150';
        
        Test.startTest();
        
        update cardFromSetup;
        
        Test.stopTest();
        
        System.assertEquals(null, [SELECT Account__c 
                                   FROM Scanned_Business_Cards__c 
                                   WHERE Account_Name__c = 'noMatchingAccount150'].Account__c);
        
    }
    
    @isTest static void matchingAccountDeleted() {
        
        Account accountFromSetup = [SELECT Name FROM Account
                                    WHERE Name = 'singleAccount'];
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Account_Name__c, Account__c 
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE Account_Name__c = 'accountName0'];
        
        cardFromSetup.Account_Name__c = 'singleAccount';
        
        Test.startTest();
        
        update cardFromSetup;
        
        Test.stopTest();
        
        System.assertEquals([SELECT Account__c 
                             FROM Scanned_Business_Cards__c 
                             WHERE Account_Name__c = 'singleAccount'].Account__c, accountFromSetup.Id);  
        
        Database.delete(accountFromSetup, true);
        
        System.assertEquals(null, [SELECT Account__c 
                                   FROM Scanned_Business_Cards__c 
                                   WHERE Account_Name__c = 'singleAccount'].Account__c);
        
    }
    
    @isTest static void firstAndLatNameUpdated_OneContactFound() {
        
        Contact contactFromSetup = [SELECT Id, FirstName, LastName FROM Contact
                                    WHERE FirstName = 'singleContact' 
                                    AND LastName = 'singleContact'];
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT First_Name__c, Last_Name__c, Contact__c
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE First_Name__c = 'firstName0' 
                                                   AND Last_Name__c = 'lastName0'];
        
        cardFromSetup.First_Name__c = 'singleContact';
        cardFromSetup.Last_Name__c = 'singleContact';
        
        Test.startTest();
        update cardFromSetup;
        Test.stopTest();
        
        System.assertEquals([SELECT Contact__c
                             FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'singleContact' 
                             AND Last_Name__c = 'singleContact'].Contact__c, contactFromSetup.Id);
        
    }
    
    @isTest static void firstAndLatNameUpdated_NoneContactFound() {
        
        Contact contactFromSetup = [SELECT Id, FirstName, LastName FROM Contact
                                    WHERE FirstName = 'singleContact' 
                                    AND LastName = 'singleContact'];
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT First_Name__c, Last_Name__c, Contact__c
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE First_Name__c = 'firstName0' 
                                                   AND Last_Name__c = 'lastName0'];
        
        cardFromSetup.First_Name__c = 'singleContactNoFound';
        cardFromSetup.Last_Name__c = 'singleContactNoFound';
        
        Test.startTest();
        
        update cardFromSetup;
        
        Test.stopTest();
        
        System.assertEquals(null, [SELECT Contact__c
                                   FROM Scanned_Business_Cards__c 
                                   WHERE First_Name__c = 'singleContactNoFound' 
                                   AND Last_Name__c = 'singleContactNoFound'].Contact__c);
        
    }
    
    @isTest static void firstNameUpdated_NoMatchingContact() {
        
        Contact contactFromSetup = [SELECT Id, FirstName, LastName FROM Contact
                                    WHERE FirstName = 'singleContact' 
                                    AND LastName = 'singleContact'];
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT First_Name__c, Last_Name__c, Contact__c
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE First_Name__c = 'firstName0' 
                                                   AND Last_Name__c = 'lastName0'];
        
        cardFromSetup.First_Name__c = 'singleContact';
        
        Test.startTest();
        
        update cardFromSetup;
        
        Test.stopTest();
        
        System.assertEquals(null, [SELECT Contact__c
                                   FROM Scanned_Business_Cards__c 
                                   WHERE First_Name__c = 'singleContact'].Contact__c);
        
    }
    
    @isTest static void lastNameUpdated_NoMatchingContact() {
        
        Contact contactFromSetup = [SELECT Id, FirstName, LastName FROM Contact
                                    WHERE FirstName = 'singleContact' 
                                    AND LastName = 'singleContact'];
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT First_Name__c, Last_Name__c, Contact__c
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE First_Name__c = 'firstName0' 
                                                   AND Last_Name__c = 'lastName0'];
        
        cardFromSetup.Last_Name__c = 'singleContact281';
        
        Test.startTest();
        
        update cardFromSetup;
        
        Test.stopTest();
        
        System.assertEquals(null, [SELECT Contact__c
                                   FROM Scanned_Business_Cards__c 
                                   WHERE Last_Name__c = 'singleContact281'].Contact__c);
        
    }
    
    @isTest static void firstAndLatNameUpdated_MultipleContactsFound_ContactLookupIsPopulated() {
        
        insert new Contact(FirstName = 'contactDelay', LastName = 'contactDelay');
        ContactTestUtilities.sleep(2000);
        insert new Contact(FirstName = 'contactDelay', LastName = 'contactDelay');
        ContactTestUtilities.sleep(2000);
        insert new Contact(FirstName = 'contactDelay', LastName = 'contactDelay', Email = 'theYoungest@contact.com');
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Contact__c 
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE First_Name__c = 'firstName0'
                                                   AND Last_Name__c = 'lastName0'];
        
        cardFromSetup.First_Name__c = 'contactDelay';
        cardFromSetup.Last_Name__c = 'contactDelay';
        
        Test.startTest();
        update cardFromSetup;
        Test.stopTest();
        
        System.assertEquals([SELECT Contact__c 
                             FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'contactDelay'
                             AND Last_Name__c = 'contactDelay'].Contact__c, 
                            [SELECT Id FROM Contact WHERE Email = 'theYoungest@contact.com'].Id);
    }
    
    @isTest static void createContact_ContactLookupIsPopulated() {
        
        Scanned_Business_Cards__c cardFromSetup = [SELECT Contact__c 
                                                   FROM Scanned_Business_Cards__c 
                                                   WHERE First_Name__c = 'firstName0'
                                                   AND Last_Name__c = 'lastName0'];
        
        Test.startTest();
        
        insert new Contact(FirstName = 'firstName0', LastName = 'lastName0');
        
        Test.stopTest();
        
        System.assertEquals([SELECT Contact__c 
                             FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'firstName0'
                             AND Last_Name__c = 'lastName0'].Contact__c, [SELECT Id FROM Contact 
                                                                            WHERE FirstName = 'firstName0' 
                                                                            AND LastName = 'lastName0'
                                                                            ORDER BY CreatedDate DESC 
                                                                            LIMIT 1].Id);
        
    }

}