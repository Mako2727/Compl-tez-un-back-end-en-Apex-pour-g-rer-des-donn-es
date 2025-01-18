public with sharing class OrderService {
    @AuraEnabled(Cacheable=true)
    // Méthode pour valider les commandes
    public static void validateOrder(Order orderToValidate) {
        // TODO: Implémenter la logique de validation de la commande
    }

    @AuraEnabled(Cacheable=true)
    public static Prix__c getBestPrice(Id opportunityId) {
        System.debug('OpportunityId= '+ OpportunityId);
        Opportunity acc = AccountSelector.getAccountByOppId(OpportunityId);  //a partir de l opportunité je recupere le accountID     
        
       string TypeClient= acc.Account.TypeClient__c;              
       string Pays=acc.Account.ShippingCountry;   

    List<Prix__c> transporteurs = TransporterSelector.getTransporteurOrderByPriceDesc(pays, typeClient);

    Prix__c lowerPriceTransporter = transporteurs[0]; 
    System.debug('Transporteur le plus rapide trouvé : ' + lowerPriceTransporter.TransporteurID__r.Name);
    return lowerPriceTransporter;
    }

    @AuraEnabled(Cacheable=true)
    public static Prix__c getFasterDelivery(Id opportunityId) {
        Opportunity acc = AccountSelector.getAccountByOppId(OpportunityId);  //a partir de l opportunité je recupere le accountID          
        
        string TypeClient= acc.Account.TypeClient__c;              
        string Pays=acc.Account.ShippingCountry;  
    List<Prix__c> transporteurs = TransporterSelector.getTransporteurOrderByFasterDesc(pays, typeClient);
    Prix__c fastestTransporter = transporteurs[0]; // Le plus rapide est le premier de la liste
    System.debug('Transporteur le plus rapide trouvé : ' + fastestTransporter.TransporteurID__r.Name);
    return fastestTransporter;
    }

    @AuraEnabled(Cacheable=true)
    public static void CreateLivraison(string Status,string OpportunityId,string shippingOption)
    {
        try {
            TransporterSelector.CreateShipping(Status,OpportunityId,shippingOption);
            System.debug('insertion dans Livraison ok  sur Order');
        } catch (Exception ex ) {
            System.debug('Erreur insert ...'+ ex);
        }
        
    }

    //TODO : Completer la classe avec toute autre méthode nécessaire pour gérer la logique métier liée aux commandes

}