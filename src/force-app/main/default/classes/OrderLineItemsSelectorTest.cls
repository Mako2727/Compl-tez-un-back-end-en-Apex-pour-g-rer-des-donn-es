@IsTest
private class OrderLineItemsSelectorTest {
    @TestSetup
    static void setup() {

         TestDataFactory.testGetOrderItemByIds();
    }

    @IsTest
    static void testgetNumberOfProduct()
    {
        OrderItem  ordItem = [SELECT Id FROM OrderItem LIMIT 1 ];
        // Vérification de l'existence de l'enregistrement avant d'appeler la méthode
        System.assertNotEquals( null,  ordItem,'No ordItem was found in the test data' );
        Test.startTest();
        // Appel de la méthode testée
        List<OrderItem>  results = OrderLineItemsSelector.getNumberOfProduct(ordItem.Id);
        Test.stopTest();
    
        // Validation des résultats
        System.assertNotEquals(null, results, 'Results should not be null');
    }




}