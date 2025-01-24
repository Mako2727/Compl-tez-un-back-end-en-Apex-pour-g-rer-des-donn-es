public with sharing class OrderService {
    @AuraEnabled(Cacheable=true)
    // Méthode pour valider les commandes
    public static void validateOrder(Order orderToValidate) {
        // TODO: Implémenter la logique de validation de la commande
    }

    @AuraEnabled(Cacheable=true)
    public static Boolean getcheckOrder(Id ordID )
    {  Boolean bCheck=true;
        try {
              //je verifie qu'il y a des produit avant de lui proposer une livraison
        List<OrderItem> OrderItem=  OrderLineItemsSelector.getNumberOfProduct(ordID);
        System.debug('OrderItem.size()= '+ OrderItem.size());
        System.debug('ordID= '+ ordID);
      
        if (OrderItem.size()>0)
          {
            bCheck=true;
          }
          else {
            bCheck=false;
          }
        } catch (Exception ex) {
         
            System.debug(' Error OrderItem.size() '+ ex.getMessage());
        }
       
          return bCheck;

    }

    @AuraEnabled(Cacheable=true)
    public static Prix__c getBestPrice(Id orderId) {
        //System.debug('orderId= '+ orderId);
        Order ord = AccountSelector.getAccountByOppId(orderId);  //a partir de l order je recupere le accountID    
       string TypeClient= ord.Account.TypeClient__c;              
       string Pays=ord.Account.ShippingCountry;   
    List<Prix__c> transporteurs = TransporterSelector.getTransporteurOrderByPriceDesc(pays, typeClient);
    Prix__c lowerPriceTransporter = transporteurs[0]; 
    //System.debug('Transporteur le plus rapide trouvé : ' + lowerPriceTransporter.TransporteurID__r.Name);
    return lowerPriceTransporter;
    }

    @AuraEnabled(Cacheable=true)
    public static Prix__c getFasterDelivery(Id orderId) {  
          Order ord = AccountSelector.getAccountByOppId(orderId);  //a partir de l opportunité je recupere le accountID    
        string TypeClient= ord.Account.TypeClient__c;              
        string Pays=ord.Account.ShippingCountry;  
    List<Prix__c> transporteurs = TransporterSelector.getTransporteurOrderByFasterDesc(pays, typeClient);
    Prix__c fastestTransporter = transporteurs[0]; // Le plus rapide est le premier de la liste
    //System.debug('Transporteur le plus rapide trouvé : ' + fastestTransporter.TransporteurID__r.Name);
    return fastestTransporter;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Prix__c> getOtherTransporteur(Id orderId) {
        Order ord = AccountSelector.getAccountByOppId(orderId);  //a partir de l opportunité je recupere le accountID   
        string TypeClient= ord.Account.TypeClient__c;              
        string Pays=ord.Account.ShippingCountry;  
    List<Prix__c> transporteurs = TransporterSelector.getOtherTransporteur(pays);
    //Prix__c OtherTransporter = transporteurs; // Le plus rapide est le premier de la liste
    //System.debug('Nombre de Transporteurs : ' + transporteurs.size());
    return transporteurs;
    }
    


    @AuraEnabled(Cacheable=false)
    public static void CreateLivraison(string Status,string OrderId,string shippingOption,string TransporteurName,string transporteurid)
    {
        try {
            TransporterSelector.CreateShipping(Status,OrderId,shippingOption,TransporteurName,transporteurid);
            //System.debug('insertion dans Livraison ok  sur Order');
        } catch (Exception ex ) {
            System.debug('Erreur insert ...'+ ex);
        }
        
    }

    //TODO : Completer la classe avec toute autre méthode nécessaire pour gérer la logique métier liée aux commandes

}