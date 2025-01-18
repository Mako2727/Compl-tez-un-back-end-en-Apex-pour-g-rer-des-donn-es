public with sharing class AccountSelector {
    public static Account getAccountById(Id accountId) {
        return [
                SELECT Id, Name, Type, Industry, BillingCity, BillingCountry, Phone, Website,TypeClient__c,ShippingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode
                FROM Account
                WHERE Id = :accountId LIMIT 1 ];
    }


    public static Opportunity getAccountByOppId(Id oppId) {
        return [
            SELECT Id, Name,Account.ShippingCountry,Account.TypeClient__c
            FROM Opportunity
                WHERE Id = :oppId LIMIT 1 ];
    }
}

   