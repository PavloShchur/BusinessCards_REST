@isTest
public class AccountTriggerTest {
    
    @testSetup static void setup() {
        
        List<Scanned_Business_Cards__c> listOfCards = new List<Scanned_Business_Cards__c>();
        List<Account> accounts = new List<Account>();
        List<Account> checkCreatedDate = new List<Account>();
        
        for(Integer i = 0; i < 100; i++) {
            
            listOfCards.add(
                
                new Scanned_Business_Cards__c(
                    
                    Account_Name__c = 'accountName' + i,
                    First_Name__c = 'firstName' + i,
                    Last_Name__c = 'lastName' + i,
                    Created_By_Id__c = '0050O000006eb3n',
                    Phone__c = '12345'
                    
                ));  
            
        }
        
        insert listOfCards;
        
        for(Integer i = 0; i < 100; i++) {
            
            accounts.add(
                new Account(                    
                    Name = 'accountName' + i
                ));      
            
            accounts.add(
                new Account(                    
                    Name = 'custom@id.com' ,
                    Site = 'custom@id.com'
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
        
        insert new Account (Name = 'testAccount97');
        insert new Account (Name = 'testAccount97');
        insert new Account (Name = 'testAccount97', Site = 'theLast@Account.com');
        
    } 
    
    @isTest static void createAccount_CardFound() {
        
        Account newAccount = new Account(Name = 'accountName0');
        
        Test.startTest();
        
        insert newAccount;
        
        Test.stopTest();
        
        System.assertEquals(newAccount.Id, [SELECT Account__c 
                                            FROM Scanned_Business_Cards__c 
                                            WHERE Account_Name__c = 'accountName0'].Account__c);     
    }
    
    @isTest static void createAccount_NoCardFound() {
        
        Account newAccount = new Account(Name = 'noMatchingCard');
        
        Test.startTest();
        insert newAccount;
        Test.stopTest();
        
        System.assertEquals(true, [SELECT Account__c 
                                   FROM Scanned_Business_Cards__c 
                                   WHERE Account__c = :newAccount.Id].isEmpty());     
        
    }
    
    static void createMultipleAccounts_CardFound() {
        
        Test.startTest();
        insert new Scanned_Business_Cards__c(Account_Name__c = 'testAccount97', 
                                             Created_By_Id__c = '0050O000006eb3n'); 
        Test.stopTest();
        
        System.assertEquals([SELECT Id 
                             FROM Account 
                             WHERE Name = 'testAccount97'
                             AND Site = 'theLast@Account.com'].Id, 
                            
                            [SELECT Account_Name__c, Account__c 
                             FROM Scanned_Business_Cards__c 
                             WHERE Account_Name__c = 'testAccount97'].Account__c); 
    }
    
    @isTest public static void updateAccount_CardFound() {
        
        List<Account> accountsToUpdate = new List<Account>();
        
        Scanned_Business_Cards__c newCard = new Scanned_Business_Cards__c(Account_Name__c = 'account0', 
                                                                          Created_By_Id__c = '0050O000006eb3n');
        
        insert newCard;
        
        Account acct_1 = new Account(Name = 'accountName0');
        Account acct_2 = new Account(Name = 'accountName0'); 
        Account acct_3 = new Account(Name = 'accountName0'); 
        
        accountsToUpdate.add(acct_1);
        accountsToUpdate.add(acct_2);
        accountsToUpdate.add(acct_3);
        
        Test.startTest();
        insert accountsToUpdate;
        Test.stopTest();
        
        accountsToUpdate[2].Name = 'account0';
        
        update accountsToUpdate;
        
        System.assertEquals([SELECT Id 
                             FROM Account
                             WHERE Name = 'account0'].Id, [SELECT Account__c, Account_Name__c
                                                           FROM Scanned_Business_Cards__c
                                                           WHERE Account_Name__c = 'account0'].Account__c);
    }
    
    @isTest public static void deleteRelatedAccount_AccountLookupEmpty() {
                
        Test.startTest();  
        Database.delete([SELECT Id FROM Account WHERE Name = 'accountName0']);
        Test.stopTest();
        
        System.assertEquals(null, [SELECT Account__c FROM Scanned_Business_Cards__c WHERE Account_Name__c = 'accountName0'].Account__c);
        
    }
    
    @isTest public static void deleteRelatedAccount_AccountLookupNotEmpty() {
                        
        Test.startTest();
        insert new Account(Name = 'accountName0', Website = 'theYoungeds');
        Database.delete([SELECT Id FROM Account WHERE Name = 'accountName0' AND Website = 'theYoungeds']);
        Test.stopTest();
                
        System.assertEquals([SELECT Id FROM Account WHERE Name = 'accountName0'].Id, 
                            [SELECT Account__c FROM Scanned_Business_Cards__c WHERE Account_Name__c = 'accountName0'].Account__c);
        
    }
    
}