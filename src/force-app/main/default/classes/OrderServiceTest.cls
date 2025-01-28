@IsTest
private class OrderServiceTest {
  @TestSetup
  static void setup() {
    TestDataFactory.createTestOrders();
    TestDataFactory.createTestgetTransporteurPrice();
    TestDataFactory.createTestgetTransporteurDelai();
    TestDataFactory.testtestvalidateOrderPro();
    TestDataFactory.testtestvalidateOrderParticulier();
  }

  @IsTest
  static void testgetBestPrice() {
    List<Order> ord = [SELECT Id FROM Order LIMIT 1];
    Test.startTest();
    Prix__c results = OrderService.getBestPrice(ord[0].Id);
    Test.stopTest();
    System.assertEquals(
      'best_Price_Transporteur',
      results.TransporteurID__r.name,
      'Le transporteur devrait etre best_Price_Transporteur le prix est de ' +
      results.Tarif__c
    );
  }

  @IsTest
  static void testgetFasterDelivery() {
    List<Order> ord = [SELECT Id FROM Order LIMIT 1];
    Test.startTest();
    Prix__c results = OrderService.getFasterDelivery(ord[0].Id);
    Test.stopTest();
    System.assertEquals(
      'faster_Transporteur',
      results.TransporteurID__r.name,
      'Le transporteur devrait etre faster_Transporteur le delai est de ' +
      results.DelaiDeLivraisonJours__c
    );
  }

  @IsTest
  static void testgetOtherTransporteur() {
    List<Order> ord = [SELECT Id FROM Order LIMIT 1];
    Test.startTest();
    List<Prix__c> results = OrderService.getOtherTransporteur(ord[0].Id);
    Test.stopTest();
    System.assert(
      results != null && results.size() > 0,
      'Les résultats ne peuvent pas être nuls ou vides'
    );
  }

  @IsTest
  static void testCreateLivraison() {
    List<Order> ord = [SELECT Id FROM Order LIMIT 1];
    List<Transporteur__c> transp = [SELECT Id FROM Transporteur__c LIMIT 1];
    string transpId = transp[0].Id;
    String ordId = ord[0].Id;
    Test.startTest();
    OrderService.CreateLivraison(
      'en cours',
      ordId,
      'fastest',
      'test Livraison',
      transpId
    );
    Test.stopTest();
    List<Livraison__c> results = [SELECT Id FROM Livraison__c LIMIT 1];
    System.assert(
      results != null && results.size() > 0,
      'Les résultats ne peuvent pas être nuls ou vides'
    );
  }

  @IsTest
  static void testgetcheckOrder() {
    List<OrderItem> odItem = TestDataFactory.testGetOrderItemByIds();
    Test.startTest();
    Boolean results = OrderService.getcheckOrder(odItem[0].OrderId);
    Test.stopTest();
    System.assertEquals(true, results, 'La methode doit renvoyer True');
  }

  @IsTest
  static void testvalidateOrderPro() {
    List<Order> ord = [
      SELECT Id
      FROM Order
      WHERE Status = 'Draft' AND account.Name = 'Test Professionnel'
      LIMIT 1
    ];
    try {
      Test.startTest();
      Order orderToUpdate = [SELECT Id, Status FROM Order WHERE Id = :ord[0].Id];
      orderToUpdate.Status = 'Activated';
      update orderToUpdate;
      Test.stopTest();
  } catch (Exception e) {
      System.debug('Exception during test: ' + e.getMessage());
  }
    Order updatedOrder = [SELECT Id, Status FROM Order WHERE Id = :ord[0].Id];
    System.assertEquals( 'Draft',  updatedOrder.Status,'Le statut devrait être "Draft'  );
    //System.debug('New status!!!='+ updatedOrder.Status);
  }


  @IsTest
  static void testtestvalidateOrderParticulier()
  {
    List<Order> ord = [
      SELECT Id
      FROM Order
      WHERE Status = 'Draft' AND account.Name = 'Test Particulier'
      LIMIT 1
    ];
    try {
      Test.startTest();
      Order orderToUpdate = [SELECT Id, Status FROM Order WHERE Id = :ord[0].Id];
      orderToUpdate.Status = 'Activated';
      update orderToUpdate;
      Test.stopTest();
  } catch (Exception e) {
      System.debug('Exception during test: ' + e.getMessage());
  }
    Order updatedOrder = [SELECT Id, Status FROM Order WHERE Id = :ord[0].Id];
    System.assertEquals( 'Draft',  updatedOrder.Status,'Le statut devrait être "Draft'  );
    //System.debug('New status!!!='+ updatedOrder.Status);

  }
}
