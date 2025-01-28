@IsTest
public class TestDataFactory {
  @IsTest
  public static void createTestgetTransporteurDelai() {
    //je créé un transporteur1
    Transporteur__c testTransporteur1 = new Transporteur__c(
      Name = 'faster_Transporteur',
      TypeClient__c = 'Particulier'
    );
    insert testTransporteur1;

    //je cree un prix1
    Prix__c testPrix1 = new Prix__c(
      Name = 'prix1',
      Tarif__c = '9',
      DelaiDeLivraisonJours__c = '3',
      TransporteurID__c = testTransporteur1.Id,
      Pays__c = 'France'
    );
    insert testPrix1;

    System.debug('Transporteur1: ' + testTransporteur1);
    System.debug('Prix1: ' + testPrix1);
  }
  @IsTest
  public static void createTestgetTransporteurPrice() {
    //je créé un transporteur2
    Transporteur__c testTransporteur2 = new Transporteur__c(
      Name = 'best_Price_Transporteur',
      TypeClient__c = 'Particulier'
    );
    insert testTransporteur2;

    //je cree un prix2
    Prix__c testPrix2 = new Prix__c(
      Name = 'prix2',
      Tarif__c = '2',
      DelaiDeLivraisonJours__c = '99',
      TransporteurID__c = testTransporteur2.Id,
      Pays__c = 'France'
    );
    insert testPrix2;

    System.debug('Transporteur2: ' + testTransporteur2);
    System.debug('Prix2: ' + testPrix2);
  }

  @IsTest
  public static List<Order> createTestOrders() {
    Integer numberOfOrders = 5; // Nombre de commandes à créer
    Account testAccount = new Account(
      Name = 'Test Account',
      ShippingStreet = '123 Main St', // Rue
      ShippingCity = 'City', // Ville
      ShippingState = '', // État
      ShippingPostalCode = '12345', // Code postal
      ShippingCountry = 'France', // Pays
      TypeClient__c = 'Particulier'
    );
    insert testAccount;

    // Création des commandes
    List<Order> testOrders = new List<Order>();
    for (Integer i = 0; i < numberOfOrders; i++) {
      testOrders.add(
        new Order(
          AccountId = testAccount.Id,
          EffectiveDate = Date.today().addDays(i),
          Status = 'Draft'
        )
      );
    }
    insert testOrders;
    return testOrders;
  }

  public static List<OrderItem> createTestOrderItems(List<Order> orders) {
    List<OrderItem> orderItems = new List<OrderItem>();
    for (Order ord : orders) {
      orderItems.add(
        new OrderItem(
          OrderId = ord.Id,
          Quantity = 1, // Exemple de valeur pour Quantity
          UnitPrice = 10.0 // Exemple de valeur pour UnitPrice
        )
      );
    }
    insert orderItems;
    return orderItems;
  }

  @IsTest
  public static List<OrderItem> testGetOrderItemByIds() {
    Account testAccount = new Account(
      Name = 'Test Account',
      ShippingStreet = '123 Main St', // Rue
      ShippingCity = 'City', // Ville
      ShippingState = '', // État
      ShippingPostalCode = '12345', // Code postal
      ShippingCountry = 'France', // Pays
      TypeClient__c = 'Particulier'
    );
    insert testAccount;

    // Récupérer le Pricebook standard
    Id standardPricebookId = Test.getStandardPricebookId();

    // Créer un produit de test
    Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
    insert testProduct;

    // Créer une entrée de prix standard pour le produit
    PricebookEntry standardPricebookEntry = new PricebookEntry(
      Pricebook2Id = standardPricebookId,
      Product2Id = testProduct.Id,
      UnitPrice = 100.0, // Exemple de prix standard
      IsActive = true
    );
    insert standardPricebookEntry;

    // Créer des commandes de test
    List<Order> testOrders = new List<Order>();
    for (Integer i = 0; i < 3; i++) {
      testOrders.add(
        new Order(
          AccountId = testAccount.Id,
          EffectiveDate = Date.today().addDays(i),
          Status = 'Draft',
          Pricebook2Id = standardPricebookId // Associer le Pricebook standard à l'Order
        )
      );
    }
    insert testOrders;

    // Créer des OrderItems associés aux commandes
    List<OrderItem> testOrderItems = new List<OrderItem>();
    for (Order ord : testOrders) {
      testOrderItems.add(
        new OrderItem(
          OrderId = ord.Id,
          PricebookEntryId = standardPricebookEntry.Id, // Lier l'OrderItem au PricebookEntry
          Quantity = 1, // Exemple de valeur pour Quantity
          UnitPrice = 10.0 // Exemple de valeur pour UnitPrice
        )
      );
    }
    insert testOrderItems;

    // Récupérer les IDs des commandes
    Set<Id> orderIds = new Set<Id>();
    for (Order ord : testOrders) {
      orderIds.add(ord.Id);
    }
    List<OrderItem> orderItems = OrderSelector.getOrderItemByIds(orderIds);
    return orderItems;
  }

  @IsTest
  public static void testtestvalidateOrderPro() {
    Account testAccount = new Account(
      Name = 'Test Professionnel',
      ShippingStreet = '123 Main St', // Rue
      ShippingCity = 'City', // Ville
      ShippingState = '', // État
      ShippingPostalCode = '12345', // Code postal
      ShippingCountry = 'France', // Pays
      TypeClient__c = 'Professionnel'
    );
    insert testAccount;

    // Récupérer le Pricebook standard
    Id standardPricebookId = Test.getStandardPricebookId();

    // Créer un produit de test
    Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
    insert testProduct;

    // Créer une entrée de prix standard pour le produit
    PricebookEntry standardPricebookEntry = new PricebookEntry(
      Pricebook2Id = standardPricebookId,
      Product2Id = testProduct.Id,
      UnitPrice = 100.0, // Exemple de prix standard
      IsActive = true
    );
    insert standardPricebookEntry;

    // Créer d une commandes de test
    List<Order> testOrders = new List<Order>();
    testOrders.add(
      new Order(
        AccountId = testAccount.Id,
        EffectiveDate = Date.today(),
        Status = 'Draft',
        Pricebook2Id = standardPricebookId // Associer le Pricebook standard à l'Order
      )
    );

    insert testOrders;

    // Créer des OrderItems associés aux commandes
    List<OrderItem> testOrderItems = new List<OrderItem>();
    for (Order ord : testOrders) {
      testOrderItems.add(
        new OrderItem(
          OrderId = ord.Id,
          PricebookEntryId = standardPricebookEntry.Id, // Lier l'OrderItem au PricebookEntry
          Quantity = 1, // Exemple de valeur pour Quantity
          UnitPrice = 10.0 // Exemple de valeur pour UnitPrice
        )
      );
    }
    insert testOrderItems;
  }


  @IsTest
  public static void testtestvalidateOrderParticulier() {
    Account testAccount = new Account(
      Name = 'Test Particulier',
      ShippingStreet = '123 Main St', // Rue
      ShippingCity = 'City', // Ville
      ShippingState = '', // État
      ShippingPostalCode = '12345', // Code postal
      ShippingCountry = 'France', // Pays
      TypeClient__c = 'Particulier'
    );
    insert testAccount;

    // Récupérer le Pricebook standard
    Id standardPricebookId = Test.getStandardPricebookId();

    // Créer un produit de test
    Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true);
    insert testProduct;

    // Créer une entrée de prix standard pour le produit
    PricebookEntry standardPricebookEntry = new PricebookEntry(
      Pricebook2Id = standardPricebookId,
      Product2Id = testProduct.Id,
      UnitPrice = 100.0, // Exemple de prix standard
      IsActive = true
    );
    insert standardPricebookEntry;

    // Créer d une commandes de test
    List<Order> testOrders = new List<Order>();
    testOrders.add(
      new Order(
        AccountId = testAccount.Id,
        EffectiveDate = Date.today(),
        Status = 'Draft',
        Pricebook2Id = standardPricebookId 
      )
    );

    insert testOrders;

    // Créer des OrderItems associés aux commandes
    List<OrderItem> testOrderItems = new List<OrderItem>();
    for (Order ord : testOrders) {
      testOrderItems.add(
        new OrderItem(
          OrderId = testOrders[0].Id,
          PricebookEntryId = standardPricebookEntry.Id, 
          Quantity = 1, 
          UnitPrice = 10.0 
        )
      );
    }
    insert testOrderItems;
  }
}
