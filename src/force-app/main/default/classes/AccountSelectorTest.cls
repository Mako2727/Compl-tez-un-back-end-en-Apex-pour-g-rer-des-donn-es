@IsTest
private class AccountSelectorTest {
    @TestSetup
    static void setup() {
    // Création d'un compte de test
     TestDataFactory.createTestOrders();
    }

    @IsTest
    static void testgetAccountByOppId()
    {
        Order  ord = [SELECT Id FROM Order LIMIT 1 ];
          // Vérification de l'existence de l'enregistrement avant d'appeler la méthode
          System.assertNotEquals( null,  ord,'No Order was found in the test data' );
          Test.startTest();
          // Appel de la méthode testée          
          Order  results = AccountSelector.getAccountByOppId(ord.Id);
          Test.stopTest();
      
          // Validation des résultats
          System.assertNotEquals(null, results, 'Results should not be null');
    }


}