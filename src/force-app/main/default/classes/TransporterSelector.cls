public with sharing class TransporterSelector {
    public static List<Prix__c> getTransporteurOrderByPriceDesc(string Pays,string TypeClient) {
        return [
            SELECT Id, TransporteurID__c, DelaiDeLivraisonJours__c,Pays__c,tarif__c,TransporteurID__r.TypeClient__c,TransporteurID__r.name 
            FROM Prix__c  
            where pays__c=:Pays and TransporteurID__r.TypeClient__c LIKE :('%' + TypeClient + '%')
            order by tarif__c asc
            limit 1
            ];
    }

    public static List<Prix__c> getTransporteurOrderByFasterDesc(string Pays,string TypeClient) {
        return [
            SELECT Id, TransporteurID__c, DelaiDeLivraisonJours__c,Pays__c,tarif__c,TransporteurID__r.TypeClient__c,TransporteurID__r.name 
            FROM Prix__c  
            where pays__c=:Pays and TransporteurID__r.TypeClient__c LIKE :('%' + TypeClient + '%')
            order by DelaiDeLivraisonJours__c asc
            limit 1
            ];
    }

    public static List<Prix__c> getOtherTransporteur(string Pays) {
        return [
            SELECT Id, TransporteurID__c, DelaiDeLivraisonJours__c,Pays__c,tarif__c,TransporteurID__r.TypeClient__c,TransporteurID__r.name 
            FROM Prix__c  
            where pays__c=:Pays 
            order by DelaiDeLivraisonJours__c asc
            ];
    }

    public static void CreateShipping(String Status, String OrderId, String shippingOption,string TransporteurName) {
        try {
            System.debug('Status=' + Status);
            System.debug('OrderId='+ OrderId);
            System.debug('shippingOption='+shippingOption);
            System.debug('TransporteurName='+TransporteurName);
            //List<Livraison__c> livraisonsToInsert = new List<Livraison__c>();
            Livraison__c newLivraison = new Livraison__c(
                Status__c = Status, 
                OrderLivraison__c = OrderId,
                shippingOption__c = shippingOption,
                Name=TransporteurName
            );
           // livraisonsToInsert.add(newLivraison);
            insert newLivraison;  // Un seul DML pour tous les enregistrements
            System.debug('Insertion dans Livraison ok');
        } catch (Exception ex) {
            System.debug('Erreur insert ...' + ex.getMessage());
        }
    }



}