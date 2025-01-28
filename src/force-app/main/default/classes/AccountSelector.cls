public with sharing class AccountSelector {
  public static Order getAccountByOppId(Id orderId) {
    return [
      SELECT Id, Name, Account.ShippingCountry, Account.TypeClient__c
      FROM Order
      WHERE Id = :orderId
      LIMIT 1
    ];
  }
}
