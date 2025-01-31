public with sharing class OrderSelector {
  public static List<order> getOrderByIds(Set<Id> orderIds) {
    List<Order> ordersToProcess = [SELECT Id FROM Order WHERE Id IN :orderIds]; //conversion en list Order
    List<order> orders = [
      SELECT Id, Status, AccountId, account.Type
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


  public static Order getAccountByOppId(Id orderId) {
    return [
      SELECT Id, Name, Account.ShippingCountry, Account.Type
      FROM Order
      WHERE Id = :orderId
      LIMIT 1
    ];
  }
}
