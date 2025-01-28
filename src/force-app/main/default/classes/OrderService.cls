public with sharing class OrderService {
    // Définition de l'exception personnalisée dans le même fichier
    public class OrderValidationException extends Exception {}

    // Méthode pour valider les commandes
    public  void  validateOrder(Set<Id> orderIds, Map<Id, Order> newOrderMap) 
    {

        // Récupérer les objets Order correspondants aux IDs
    List<Order> ordersToProcess =OrderSelector.getOrderByIds(orderIds);

      // Récupérer tous les OrderItems associés aux commandes
      List<OrderItem> orderItems = OrderSelector.getOrderItemByIds(orderIds);
        // Créer une map pour associer les OrderItems à leurs commandes
        Map<Id, List<OrderItem>> orderItemsMap = new Map<Id, List<OrderItem>>();
        for (OrderItem item : orderItems) {
            if (!orderItemsMap.containsKey(item.OrderId)) {
                orderItemsMap.put(item.OrderId, new List<OrderItem>());
            }
            orderItemsMap.get(item.OrderId).add(item);
        }

    
        for (Order orderToValidate : ordersToProcess)
        { System.debug('status = ' + orderToValidate.Status);  
            
                System.debug('newMap.get = ' + newOrderMap.get(orderToValidate.Id).Status);       
        if (newOrderMap.get(orderToValidate.Id).Status == 'Activated')//si le statut est en Draft avant le passer en activate je fais le controle
            {    
                System.debug('status = ' + orderToValidate.Status);    
            
               
               // Récupérer les OrderItems pour cette commande
            List<OrderItem> orderLineItems = orderItemsMap.get(orderToValidate.Id);
            Integer productCount = orderLineItems != null ? orderLineItems.size() : 0;
 
                System.debug('typeClient = ' + orderToValidate.account.TypeClient__c);
                System.debug('productCount = ' + productCount);                
                //System.debug('pays = ' + acc.ShippingCountry);                 
                
                string typeClient= orderToValidate.account.TypeClient__c;
    
                //pour les professionnel + 5 produits
                if(typeClient=='Professionnel' && productCount<5 )
                {
                    System.debug('Je ne créé pas la commande pour le Professionnel car il n y a pas assez de produit');     
                    throw new OrderValidationException('Vous devez avoir au moins 5 produit pour valider la commande!');
                    //return;//je sors
                }
                
                //pour les particuliers + 3 produits
                if(typeClient=='Particulier' && productCount<3)
                 {
                    System.debug('Je ne créé pas la commande pour le particulier car il n y a pas assez de produit');   
                    throw new OrderValidationException('Vous devez avoir au moins 3 produit pour valider la commande!');
                 }         
        }
        }
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
    List<Prix__c> transporteurs = PriceSelector.getTransporteurOrderByPriceDesc(pays, typeClient);
    Prix__c lowerPriceTransporter = transporteurs[0]; 
    //System.debug('Transporteur le plus rapide trouvé : ' + lowerPriceTransporter.TransporteurID__r.Name);
    return lowerPriceTransporter;
    }

    @AuraEnabled(Cacheable=true)
    public static Prix__c getFasterDelivery(Id orderId) {  
          Order ord = AccountSelector.getAccountByOppId(orderId);  //a partir de l opportunité je recupere le accountID    
        string TypeClient= ord.Account.TypeClient__c;              
        string Pays=ord.Account.ShippingCountry;  
    List<Prix__c> transporteurs = PriceSelector.getTransporteurOrderByFasterDesc(pays, typeClient);
    Prix__c fastestTransporter = transporteurs[0]; // Le plus rapide est le premier de la liste
    //System.debug('Transporteur le plus rapide trouvé : ' + fastestTransporter.TransporteurID__r.Name);
    return fastestTransporter;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Prix__c> getOtherTransporteur(Id orderId) {
        Order ord = AccountSelector.getAccountByOppId(orderId);  //a partir de l opportunité je recupere le accountID   
        string TypeClient= ord.Account.TypeClient__c;              
        string Pays=ord.Account.ShippingCountry;  
    List<Prix__c> transporteurs = PriceSelector.getOtherTransporteur(pays);
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