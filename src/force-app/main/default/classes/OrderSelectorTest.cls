@IsTest
private class OrderSelectorTest {
  @TestSetup
  static void setup() {
    TestDataFactory.createTestOrders();
    TestDataFactory.testGetOrderItemByIds();
  }
  @IsTest
  static void testgetOrderByIds() {
    Set<Id> orderIds = new Map<Id, Order>([SELECT Id FROM Order]).keySet();
    Test.startTest();
    List<order> results = OrderSelector.getOrderByIds(orderIds);
    Test.stopTest();
    System.assertNotEquals(
      null,
      results,
      'La liste des résultats ne doit pas être nulle'
    );
  }
  @IsTest
  static void testgetOrderItemByIds() {
    Set<Id> orderIds = new Map<Id, Order>([SELECT Id FROM Order]).keySet();
    Test.startTest();
    List<orderItem> results = OrderSelector.getOrderItemByIds(orderIds);
    Test.stopTest();
    System.assertNotEquals(
      null,
      results,
      'La liste des résultats ne doit pas être nulle'
    );
  }
}
