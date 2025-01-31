@IsTest
private class OrderSelectorTest {
  @TestSetup
  static void setup() {
    TestDataFactory.createTestOrders();
    TestDataFactory.testGetOrderItemByIds();
    TestDataFactory.createTestOrders();
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


  @IsTest
  static void testgetAccountByOppId() {
    Order ord = [SELECT Id FROM Order LIMIT 1];
    // Vérification de l'existence de l'enregistrement avant d'appeler la méthode
    System.assertNotEquals(null, ord, 'No Order was found in the test data');
    Test.startTest();
    // Appel de la méthode testée
    Order results = OrderSelector.getAccountByOppId(ord.Id);
    Test.stopTest();

    // Validation des résultats
    System.assertNotEquals(null, results, 'Results should not be null');
  }
}
