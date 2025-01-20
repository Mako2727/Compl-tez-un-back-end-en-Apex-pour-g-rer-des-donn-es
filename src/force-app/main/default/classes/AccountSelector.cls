public with sharing class AccountSelector {
    public static Account getAccountById(Id accountId) {
        return [
                SELECT Id, Name, Type, Industry, BillingCity, BillingCountry, Phone, Website,TypeClient__c,ShippingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode
                FROM Account
                WHERE Id = :accountId LIMIT 1 ];
    }


    public static Order getAccountByOppId(Id orderId) {
        return [
            SELECT Id, Name,Account.ShippingCountry,Account.TypeClient__c
            FROM Order
                WHERE Id = :orderId LIMIT 1 ];
    }
}

   