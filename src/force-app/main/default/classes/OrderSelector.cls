public with sharing class OrderSelector {
  public static List<order> getOrderByIds(Set<Id> orderIds) {
    List<Order> ordersToProcess = [SELECT Id FROM Order WHERE Id IN :orderIds]; //conversion en list Order
    List<order> orders = [
      SELECT Id, Status, AccountId, account.TypeClient__c
      FROM Order
      WHERE Id IN :ordersToProcess
    ];
    return orders;
  }

  public static List<orderItem> getOrderItemByIds(Set<Id> orderIds) {
    List<Order> ordersItemToProcess = [
      SELECT Id
      FROM Order
      WHERE Id IN :orderIds
    ]; //conversion en list Order
    List<OrderItem> orderItems = [
      SELECT OrderId, Id
      FROM OrderItem
      WHERE OrderId IN :ordersItemToProcess
    ];
    return orderItems;
  }
}
