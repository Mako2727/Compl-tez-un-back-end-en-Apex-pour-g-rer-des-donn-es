
trigger OpportunityCloseWonToOrderTrigger on Opportunity(after update,before  update) 
{

    for (Opportunity opp : Trigger.new) {
     // Vérifier si l'opportunité est passée en Close Won
     if (opp.StageName == 'Closed Won' && Trigger.oldMap.get(opp.Id).StageName != 'Closed Won')
      {       
        System.debug('L\'opportunité ' + opp.Name + ' est passée à Close Won');
            //List<Opportunity> oppsToUpdate = new List<Opportunity>();

            Account acc = AccountSelector.getAccountById(opp.AccountId);            
            // Requête toutes les linesItem
            List<OpportunityLineItem> OpportunitiesListItem = OpportunityLineItemSelector.getNumberOfProduct(opp.Id);  
            Integer  productCount=  OpportunitiesListItem.size();


            Decimal totalAmountFromLineItems = 0;
                for (OpportunityLineItem lineItem : OpportunitiesListItem) {
                    totalAmountFromLineItems += lineItem.TotalPrice;
                }
            System.debug('typeClient = ' + acc.TypeClient__c);
            System.debug('productCount = ' + productCount);                
            System.debug('pays = ' + acc.ShippingCountry);  
            
             // Créer un nouvel enregistrement Order
             Order newOrder = new Order(
                AccountId = opp.AccountId,  // Associer l'Order à l'Account
                //Opportunity__c = opp.Id,    // Associer l'Order à l'Opportunity
                Status = 'Draft',           // Mettre l'Order en statut 'Draft' (ou un autre statut si nécessaire)
                TypeClient__c = acc.TypeClient__c, // Assigner le TypeClient récupéré
                Pays__c = acc.ShippingCountry,   // Assigner le pays de livraison (ShippingCountry)
                EffectiveDate=System.today(),
                ShippingStreet = acc.ShippingStreet,
                ShippingCity = acc.ShippingCity,
                ShippingState = acc.ShippingState,
                ShippingPostalCode = acc.ShippingPostalCode,
                ShippingCountry = acc.ShippingCountry
            );
            string typeClient= acc.TypeClient__c;

            //pour les professionnel + 5 produits
            if(typeClient=='Professionnel' && productCount>5 )
            {
                System.debug('Je créé la commande pour l opportunité du professionnel');    
                insert newOrder;
                return;//je sors
            }
            
            //pour les particuliers + 3 produits
            if(typeClient=='Particulier' && productCount>3)
             {
                System.debug('Je créé la commande pour l opportunité du particulier');   
                insert newOrder;
                return;//je sors
             }
            
            
            System.debug('Le nombre de produit pour le type client n est pas suffisant');      

            
     }
     else {
         System.debug('L\'opportunité ' + opp.Name + ' est passée à Autre etape');
     }
    
    }
}