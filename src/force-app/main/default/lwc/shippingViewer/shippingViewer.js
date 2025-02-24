import { LightningElement, api, wire, track } from "lwc";
import getBestPrice from "@salesforce/apex/OrderService.getBestPrice";
import getcheckOrder from "@salesforce/apex/OrderService.getcheckOrder";
import getFasterDelivery from "@salesforce/apex/OrderService.getFasterDelivery";
import CreateLivraison from "@salesforce/apex/OrderService.CreateLivraison";
import getOtherTransporteur from "@salesforce/apex/OrderService.getOtherTransporteur";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { RefreshEvent } from "lightning/refresh";
import hasAccessUI from "@salesforce/customPermission/customPermissionDelivery";
import { refreshApex } from '@salesforce/apex';
import { getRecord } from 'lightning/uiRecordApi';


export default class shippingViewer extends LightningElement {
  @api recordId;
  @track error = {};
  wiredBestPriceResult;
  @track TransportListItem;
  @track bestPriceTransporteurName;
  @track bestPriceTransporteurCountry;
  @track bestPriceDelaiLivraison;
  @track bestPriceTarif;

  @track FasterDeliveryTransporteurName;
  @track FasterDeliveryDelaiLivraison;
  @track FasterDeliveryTarif;
  @track FasterDeliveryCountry;
  @track OptionShipping;
  @track orderId;
  @track transporteurName;
  @track Othertransporteurs;
  @track bestPriceId;
  @track FasterDeliveryPriceId;
  @track priceid;
  @track transporteurid;
  @track bestPriceTransporteurId;
  @track FasterDeliveryTransporteurId;
  @track OrderItemToDisplay;
  @track conditionMet=false;
  
  FIELDS = ['Name'];

  @wire(getRecord, { recordId: '$recordId', fields: '$FIELDS' })
  wiredRecord({ error, data }) {
      if (error) {
          console.error('Erreur de récupération des données:', error);
      } else if (data) {         
          this.checkOrderStatus(); // Appel pour mettre à jour conditionMet
      }
  }

  checkOrderStatus() {
      getcheckOrder({ ordID: this.recordId })
          .then((result) => {
            console.log('recordId==:', this.recordId);
              console.log('Données de getcheckOrder:', result);
              this.conditionMet = result; // Mise à jour de conditionMet
              console.log('conditionMet mise à jour:', this.conditionMet);
              refreshApex(this.wiredRecord); // Rafraîchit les données du composant
          })
          .catch((error) => {
              console.error('Erreur dans getcheckOrder:', error);
          });
  }



  get checkOrder() {//appel la methode getcheckOrder qui verifie que j ai au moins les conditions d affichage pour afficher les lignes
    return this.conditionMet;
  }

  get isAccessible() {//verifie les droits d acces en fonction du permission Set
    return hasAccessUI;
  }

  //le moins cher
  @wire(getBestPrice, { orderId: "$recordId" })
  wiredBestPrice(result) {
    this.orderId = this.recordId;
    const { data, error } = result;
    if (data) {
      this.bestPriceTransporteurName = data.TransporteurID__r
        ? data.TransporteurID__r.Name
        : "Nom non disponible";
      this.bestPriceDelaiLivraison = data.DelaiDeLivraisonJours__c
        ? data.DelaiDeLivraisonJours__c
        : "Nom non disponible";
      this.bestPriceTarif = data.Tarif__c
        ? data.Tarif__c
        : "Nom non disponible";
      this.bestPriceTransporteurCountry = data.Pays__c
        ? data.Pays__c
        : "Nom non disponible";
      this.bestPriceId = data.Id ? data.Id : "Nom non disponible";
      this.bestPriceTransporteurId = data.TransporteurID__c
        ? data.TransporteurID__c
        : "Nom non disponible";
    } else if (error) {
      console.log("Erreur =" + error);
    }
  }

  //le plus rapide
  @wire(getFasterDelivery, { orderId: "$recordId" })
  wiredFasterDelivery(result) {
    this.orderId = this.recordId;
    const { data, error } = result;
    if (data) {
      this.FasterDeliveryTransporteurName = data.TransporteurID__r
        ? data.TransporteurID__r.Name
        : "Nom non disponible";
      this.FasterDeliveryDelaiLivraison = data.DelaiDeLivraisonJours__c
        ? data.DelaiDeLivraisonJours__c
        : "Nom non disponible";
      this.FasterDeliveryTarif = data.Tarif__c
        ? data.Tarif__c
        : "Nom non disponible";
      this.FasterDeliveryCountry = data.Pays__c
        ? data.Pays__c
        : "Nom non disponible";
      this.FasterDeliveryPriceId = data.Id ? data.Id : "Nom non disponible";
      this.FasterDeliveryTransporteurId = data.TransporteurID__c
        ? data.TransporteurID__c
        : "Nom non disponible";
    } else if (error) {
      console.log("Erreur =" + error);
    }
  }

  //tous les autres
  @wire(getOtherTransporteur, { orderId: "$recordId" })
  wiredOtherTransporteur(result) {
    this.orderId = this.recordId;
    const { data, error } = result;
    if (data) {
      try {
        if (data) {
          const FasterDeliveryTransporteurName =
            this.FasterDeliveryTransporteurName; // Transporteur le plus rapide
          const bestPriceTransporteurName = this.bestPriceTransporteurName; // Transporteur le moins cher
          this.Othertransporteurs = data.filter((transporteur) => {//je supprime le moins cher et le plus rapide car dejà mentionné dans la vue
            return (
              transporteur.TransporteurID__r.Name !==
                FasterDeliveryTransporteurName &&
              transporteur.TransporteurID__r.Name !== bestPriceTransporteurName
            );
          });
        } else if (error) {
          //console.error("Erreur lors de la récupération des transporteurs :", error.body.message);
        }
      } catch (err) {
        console.error("Erreur inattendue :", err);
      }
    }
  }
  handleRowClick(event) {
    // Récupère l'élément radio dans la ligne
    const row = event.currentTarget;
    const radioButton = row.querySelector('input[type="radio"]');
    // Si le bouton radio existe, déclenche son événement onchange
    if (radioButton) {
      radioButton.checked = true; // Coche le bouton radio
      this.handleShippingChange({ target: radioButton }); // Déclenche l'événement onchange
    }
  }

  handleShippingChange(event) {
    try {
      const selectedValue = event.target.value; // Récupère la valeur du bouton radio sélectionné
      this.transporteurName = event.target.dataset.transporteur;
      this.priceid = event.target.dataset.priceid;
      this.transporteurid = event.target.dataset.transporteurid;
      this.OptionShipping = selectedValue;
    } catch (error) {
      console.error("Une erreur est survenue :", error.message);
    }
  }

  handleChooseShipping(event) {//clique sur le bouton choisir cette livraison
    try {
   

      if (
        typeof this.transporteurName === "undefined" ||
        this.transporteurName === undefined
      ) {
        this.showToast(
          "Erreur",
          "Vous devez choisir au moins un mode de livraison",
          "error"
        );
        return;
      }
      CreateLivraison({
        Status: "en cours",
        OrderId: this.orderId,
        shippingOption: this.OptionShipping,
        TransporteurName: this.transporteurName,
        transporteurid: this.transporteurid
      })
        .then(() => {
          this.showToast("Info", "Livraison créé avec succes", "success");
        })
        .catch((error) => {
          this.showToast(
            "Error",
            "Erreur pendant la creation de la livraison",
            "error"
          );
        });
      this.showToast("Info", "L expedition vient d etre effectué", "success");
      this.dispatchEvent(new RefreshEvent());
    } catch (error) {
      console.error("Une erreur est survenue :", error.message);
    }
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }
}
