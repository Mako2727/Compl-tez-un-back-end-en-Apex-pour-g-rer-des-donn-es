trigger OrderTrigger on Order (before update) {
    //recupere les acc 
    //recupere  List<OrderItem>
    for (Order ord : Trigger.new) {
        if (ord.Status == 'Activated' && Trigger.oldMap.get(ord.Id).Status != 'Activated') {   
          
   
               Account acc = AccountSelector.getAccountById(ord.AccountId);            
               // Requête toutes les linesItem

               List<OrderItem> OrderLineItemsSelector = OrderLineItemsSelector.getNumberOfProduct(ord.Id);  
               Integer  productCount=  OrderLineItemsSelector.size();
   
   
              /*Decimal totalAmountFromLineItems = 0;
                   for (OpportunityLineItem lineItem : OpportunitiesListItem) {
                       totalAmountFromLineItems += lineItem.TotalPrice;
                   }*/
               System.debug('typeClient = ' + acc.TypeClient__c);
               System.debug('productCount = ' + productCount);                
               System.debug('pays = ' + acc.ShippingCountry);  
               
               
               string typeClient= acc.TypeClient__c;
   
               //pour les professionnel + 5 produits
               if(typeClient=='Professionnel' && productCount<5 )
               {
                   System.debug('Je créé la commande pour l opportunité du professionnel');    
                   ord.addError(label.ErrorProduitInsuffisant);
                   return;//je sors
               }
               
               //pour les particuliers + 3 produits
               if(typeClient=='Particulier' && productCount<3)
                {
                   System.debug('Je créé la commande pour l opportunité du particulier');   
                   ord.addError(label.ErrorProduitInsuffisant);
                   return;//je sors
                }
               
               
   
               
        }
       
}
}