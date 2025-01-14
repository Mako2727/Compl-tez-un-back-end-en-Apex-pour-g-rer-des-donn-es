public with sharing class AccountSelector {
    public static Account getAccountById(Id accountId) {
        return [
                SELECT Id, Name, Type, Industry, BillingCity, BillingCountry, Phone, Website,TypeClient__c,ShippingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode
                FROM Account
                WHERE Id = :accountId LIMIT 1 ];
    }
}

   