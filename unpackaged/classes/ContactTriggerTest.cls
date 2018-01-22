@isTest
public class ContactTriggerTest {
    
    @testSetup static void setup() {
        
        List<Scanned_Business_Cards__c> listOfCards = new List<Scanned_Business_Cards__c>();
        
        List<Contact> contacts = new List<Contact>();
        
        List<Contact> checkCreatedDate = new List<Contact>();
        
        for(Integer i = 0; i < 100; i++) {
            
            listOfCards.add(
                
                new Scanned_Business_Cards__c(
                    
                    Account_Name__c = 'accountName' + i,
                    First_Name__c = 'firstName' + i,
                    Last_Name__c = 'lastName' + i,
                    Created_By_Id__c = '0050O000006eb3n'
                    
                ));  
            
        }
        
        insert listOfCards;
        
        for(Integer i = 0; i < 100; i++) {
            
            contacts.add(
                new Contact(                    
                    FirstName = 'firstName' + i,
                    LastName = 'lastName' + i
                ));      
            
            contacts.add(
                new Contact(                    
                    FirstName = 'custom@id.com' ,
                    LastName = 'custom@id.com'
                ));            
        }
        
        insert contacts;
        
        for(Integer i = 0; i < 100; i++) {
            
            checkCreatedDate.add(
                new Contact(                    
                    FirstName = 'name' ,
                    LastName = 'lastName'
                ));            
        }
        
        insert checkCreatedDate;
        
    } 
    
    @isTest static void createContact_FirstNameMatches_CardNotFound() {
        
        Contact newContact = new Contact(FirstName = 'firstName0', LastName = 'noMatchingCard');
        
        Test.startTest();
        insert newContact;
        Test.stopTest();
        
        System.assertNotEquals(newContact.Id, [SELECT Contact__c 
                                               FROM Scanned_Business_Cards__c 
                                               WHERE First_Name__c = 'firstName0'].Contact__c);     
        
    }
    
    @isTest static void ceateContact_LastNameMatches_CardNotFound() {
        
        Contact newContact = new Contact(FirstName = 'noMatchingCard', LastName = 'lastName0');
        
        Test.startTest();
        insert newContact;
        Test.stopTest();
        
        System.assertNotEquals(newContact.Id, [SELECT Contact__c 
                                               FROM Scanned_Business_Cards__c 
                                               WHERE First_Name__c = 'firstName0'].Contact__c);    
        System.assertEquals(null, [SELECT Contact__c 
                                               FROM Scanned_Business_Cards__c 
                                               WHERE First_Name__c = 'firstName0'].Contact__c);  
        
    }
    
    
    @isTest static void createContact_FirstNameAndLastNameMatches_CardFound() {
        
        Contact newContact = new Contact(FirstName = 'firstName0', LastName = 'lastName0');
        
        Test.startTest();
        insert newContact;
        Test.stopTest();
        
        System.assertEquals(newContact.Id, [SELECT Contact__c 
                                               FROM Scanned_Business_Cards__c 
                                               WHERE First_Name__c = 'firstName0'
                                               AND Last_Name__c = 'lastName0'].Contact__c);     
        
    }
    
    @isTest static void updateContact_FirstNameAndLastNameMatches_CardFound() {
        
        insert new Scanned_Business_Cards__c(First_Name__c = 'firstName_115',
                                             Last_Name__c = 'lastName_116',
                                             Created_By_Id__c = '0050O000006eb3n');
        
        Contact newContact = [SELECT FirstName, LastName 
                              FROM Contact 
                              WHERE FirstName = 'custom@id.com' 
                              AND LastName = 'custom@id.com' 
                              LIMIT 1];
        
        newContact.FirstName = 'firstName_115';
        newContact.FirstName = 'lastName_116';
        
        Test.startTest();
        update newContact;
        Test.stopTest();
        
        System.assertNotEquals(newContact.Id, [SELECT Contact__c 
                                               FROM Scanned_Business_Cards__c 
                                               WHERE First_Name__c = 'firstName_115' 
                                               AND  Last_Name__c = 'lastName_116'].Contact__c);     
        
    }
    
    @isTest static void checkWhetherLookupWasPopulatedWithRightContactId() {
        
        insert new Scanned_Business_Cards__c(First_Name__c = 'firstName144',
                                             Last_Name__c = 'lastName145',
                                             Created_By_Id__c = '0050O000006eb3n');
        
        Test.startTest();
        insert new Contact(FirstName = 'firstName144', LastName = 'lastName145');
        ContactTestUtilities.sleep(2000);
        insert new Contact(FirstName = 'firstName144', LastName = 'lastName145');
        ContactTestUtilities.sleep(2000);
        insert new Contact(FirstName = 'firstName144', LastName = 'lastName145', Email = 'theYoungest@contact.com');  
        Test.stopTest();
        
        System.assertEquals([SELECT Contact__c 
                                           FROM Scanned_Business_Cards__c 
                                           WHERE First_Name__c = 'firstName144' 
                                           AND Last_Name__c = 'lastName145'].Contact__c, 
                            [SELECT Id 
                             FROM Contact 
                             WHERE Email = 'theYoungest@contact.com'].Id ); 
    }
    
    @isTest public static void deleteRelatedContact_ContactLookupEmpty() {
        
		Test.startTest();
		Database.delete([SELECT Id FROM Contact WHERE FirstName = 'firstName0' AND LastName = 'lastName0']);
		Test.stopTest();
        
        System.assertEquals(null, 
                                [SELECT Contact__c FROM Scanned_Business_Cards__c 
                                 WHERE First_Name__c = 'firstName0' AND Last_Name__c = 'lastName0'].Contact__c);

    }
    
    @isTest public static void deleteRelatedContact_ContactLookupNotEmpty() {        
        
        Test.startTest();
        insert new Contact(FirstName = 'firstName0', LastName = 'lastName0', Email = 'theYoungest@contact.com');
        Database.delete([SELECT Id FROM Contact WHERE Email = 'theYoungest@contact.com']);
        Test.stopTest();
        
        System.assertEquals([SELECT Contact__c FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'firstName0' AND Last_Name__c = 'lastName0'].Contact__c, 
                            [SELECT Id FROM Contact 
                             WHERE FirstName = 'firstName0' AND LastName = 'lastName0' ORDER BY CreatedDate DESC LIMIT 1].Id
                           ); 
        
    }
    
    @isTest public static void createMultipleCardsAndMultipleContacts() {
        
        Scanned_Business_Cards__c card_1 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_1', First_Name__c = 'f_4', Last_Name__c = 'l_4');
        Scanned_Business_Cards__c card_2 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_2', First_Name__c = 'f_3', Last_Name__c = 'l_3');
        Scanned_Business_Cards__c card_3 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_3', First_Name__c = 'f_1', Last_Name__c = 'l_1');
        Scanned_Business_Cards__c card_4 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_4', First_Name__c = 'f_2', Last_Name__c = 'l_2');
        Scanned_Business_Cards__c card_5 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_5', First_Name__c = 'f_5', Last_Name__c = 'l_50');
                
        Scanned_Business_Cards__c card_6 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_5', First_Name__c = 'identical', Last_Name__c = 'identicalNo');
        Scanned_Business_Cards__c card_7 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_5', First_Name__c = 'identicalNo', Last_Name__c = 'identical');
        Scanned_Business_Cards__c card_8 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_5', First_Name__c = 'identical', Last_Name__c = 'identical');
        
        Scanned_Business_Cards__c card_9 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_5', First_Name__c = 'identical', Last_Name__c = 'identicalNo');
        Scanned_Business_Cards__c card_10 = new Scanned_Business_Cards__c(Created_By_Id__c = 'ex_Id_5', First_Name__c = 'identicalNo', Last_Name__c = 'identical');
        
        insert new List<Scanned_Business_Cards__c> {
         
         card_1,
         card_2,
         card_3,
         card_4,
         card_5,
         card_6,
         card_7,
         card_8,
         card_9,
         card_10
             
        };
        
        insert new Contact(FirstName = 'f_4', LastName = 'l_4');
        insert new Contact(FirstName = 'f_1', LastName = 'l_1');
        insert new Contact(FirstName = 'f_3', LastName = 'l_3');
        insert new Contact(FirstName = 'f_2', LastName = 'l_2');
        insert new Contact(FirstName = 'f_5', LastName = 'l_50');
        
        insert new Contact(FirstName = 'identical', LastName = 'identical');
        ContactTestUtilities.sleep(2000);
        insert new Contact(FirstName = 'identical', LastName = 'identical');
        
        insert new Contact(FirstName = 'identical', LastName = 'identicalNo');
        insert new Contact(FirstName = 'identicalNo', LastName = 'identical');
                
        System.assertEquals([SELECT Contact__c FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'f_1' AND Last_Name__c = 'l_1'].Contact__c, 
                            [SELECT Id FROM Contact 
                             WHERE FirstName = 'f_1' AND LastName = 'l_1'].Id
                           ); 
        
        System.assertEquals([SELECT Contact__c FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'f_2' AND Last_Name__c = 'l_2'].Contact__c, 
                            [SELECT Id FROM Contact 
                             WHERE FirstName = 'f_2' AND LastName = 'l_2'].Id
                           ); 

        System.assertEquals([SELECT Contact__c FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'f_3' AND Last_Name__c = 'l_3'].Contact__c, 
                            [SELECT Id FROM Contact 
                             WHERE FirstName = 'f_3' AND LastName = 'l_3'].Id
                           );         
        
        System.assertEquals([SELECT Contact__c FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'f_4' AND Last_Name__c = 'l_4'].Contact__c, 
                            [SELECT Id FROM Contact 
                             WHERE FirstName = 'f_4' AND LastName = 'l_4'].Id
                           ); 
        
        System.assertEquals([SELECT Contact__c FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'f_5' AND Last_Name__c = 'l_50'].Contact__c, 
                            [SELECT Id FROM Contact 
                             WHERE FirstName = 'f_5' AND LastName = 'l_50'].Id
                           ); 
        
        System.assertEquals([SELECT Contact__c FROM Scanned_Business_Cards__c 
                             WHERE First_Name__c = 'identical' AND Last_Name__c = 'identical'].Contact__c, 
                            [SELECT Id FROM Contact 
                             WHERE FirstName = 'identical' AND LastName = 'identical' ORDER BY CreatedDate DESC LIMIT 1].Id
                           );
        
    }
}