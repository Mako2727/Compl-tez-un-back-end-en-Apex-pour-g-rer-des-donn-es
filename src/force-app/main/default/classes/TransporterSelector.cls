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

    public static void CreateShipping(String Status, String OpportunityId, String shippingOption) {
       
    }



}