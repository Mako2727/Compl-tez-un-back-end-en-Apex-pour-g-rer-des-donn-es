public with sharing class PriceSelector {
  public static List<Prix__c> getTransporteurOrderByPriceAsc(
    string Pays,
    string TypeClient
  ) {
    return [
      SELECT
        Id,
        TransporteurID__c,
        DelaiDeLivraisonJours__c,
        Pays__c,
        tarif__c,
        TransporteurID__r.TypeClient__c,
        TransporteurID__r.name
      FROM Prix__c
      WHERE
        pays__c = :Pays
        AND TransporteurID__r.TypeClient__c =:  TypeClient 
      ORDER BY tarif__c ASC
      LIMIT 1
    ];
  }

  public static List<Prix__c> getTransporteurOrderByFasterAsc(
    string Pays,
    string TypeClient
  ) {
    return [
      SELECT
        Id,
        TransporteurID__c,
        DelaiDeLivraisonJours__c,
        Pays__c,
        tarif__c,
        TransporteurID__r.TypeClient__c,
        TransporteurID__r.name
      FROM Prix__c
      WHERE
        pays__c = :Pays
        AND TransporteurID__r.TypeClient__c  =:  TypeClient 
      ORDER BY DelaiDeLivraisonJours__c ASC
      LIMIT 1
    ];
  }

  public static List<Prix__c> getOtherTransporteur(string Pays) {
    return [
      SELECT
        Id,
        TransporteurID__c,
        DelaiDeLivraisonJours__c,
        Pays__c,
        tarif__c,
        TransporteurID__r.TypeClient__c,
        TransporteurID__r.name
      FROM Prix__c
      WHERE pays__c = :Pays
    ];
  }

  public static void CreateShipping(
    String Status,
    String OrderId,
    String shippingOption,
    string TransporteurName,
    string transporteurid
  ) {
    try {
      System.debug('Status=' + Status);
      System.debug('OrderId=' + OrderId);
      System.debug('shippingOption=' + shippingOption);
      System.debug('TransporteurName=' + TransporteurName);
      Livraison__c newLivraison = new Livraison__c(
        Status__c = Status,
        OrderLivraison__c = OrderId,
        shippingOption__c = shippingOption,
        Name = TransporteurName,
        livraisonTransporteur__c = transporteurid
      );
      insert newLivraison;
      System.debug('Insertion dans Livraison ok');
    } catch (Exception ex) {
      System.debug('Erreur insert ...' + ex.getMessage());
    }
  }
}
