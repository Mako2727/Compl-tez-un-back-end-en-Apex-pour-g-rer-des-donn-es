@IsTest
private class PriceSelectorTest {
    @TestSetup
    static void setup() {
       
        TestDataFactory.createTestgetTransporteurDelai();        
  TestDataFactory.createTestgetTransporteurPrice();
  TestDataFactory.createTestOrders();
    }

    @IsTest
    static void testgetTransporteurOrderByPriceDesc()
    {
        Test.startTest();
        List<Prix__c> results = PriceSelector.getTransporteurOrderByPriceDesc('France','Particulier');
        Test.stopTest();        
        System.assertEquals('best_Price_Transporteur', results[0].TransporteurID__r.name, 'Le transporteur devrait etre best_Price_Transporteur le prix est de '+ results[0].Tarif__c);
    }


    @IsTest
    static void testgetgetTransporteurOrderByFasterDesc()
    {
        Test.startTest();
        List<Prix__c> results = PriceSelector.getTransporteurOrderByFasterDesc('France','Particulier');
        Test.stopTest();        
        System.assertEquals('faster_Transporteur', results[0].TransporteurID__r.name, 'Le transporteur devrait etre faster_Transporteur le delai est de ' + results[0].DelaiDeLivraisonJours__c);
    }


    @IsTest
    static void testgetOtherTransporteur()
    {
        Test.startTest();
        List<Prix__c> results = PriceSelector.getOtherTransporteur('France');
        Test.stopTest();   
        // Validation des résultats
        System.assert(results != null && results.size() > 0, 'Les résultats ne peuvent pas être nuls ou vides');
        
    }

    @IsTest
    static void testCreateShipping()
    {
        List<Order> ord = [SELECT Id FROM Order LIMIT 1  ];
        List<Transporteur__c> transp = [SELECT Id FROM Transporteur__c LIMIT 1  ];
        string transpId=transp[0].Id;
        String ordId=ord[0].Id;
        Test.startTest();
                PriceSelector.CreateShipping('en cours',ordId,'fastest','test Livraison',transpId);                 
        Test.stopTest();
        List<Livraison__c> results = [SELECT Id FROM Livraison__c LIMIT 1  ]; 
        System.assert(results != null && results.size() > 0, 'Les résultats ne peuvent pas être nuls ou vides');
    }

}