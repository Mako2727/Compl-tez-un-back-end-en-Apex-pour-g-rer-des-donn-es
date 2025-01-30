public with sharing class OrderLineItemsSelector {
  public static List<OrderItem> getNumberOfProduct(Id ord) {
    List<OrderItem> orderItems = [
      SELECT Id
      FROM OrderItem
      WHERE OrderId = :ord and Order.Status='Activated'
    ];
    return orderItems;
  }
}
