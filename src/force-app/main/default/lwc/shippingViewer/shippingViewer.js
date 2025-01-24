import { LightningElement, api, wire, track } from "lwc";
import getBestPrice from "@salesforce/apex/OrderService.getBestPrice";
import getcheckOrder from "@salesforce/apex/OrderService.getcheckOrder";
import getFasterDelivery from "@salesforce/apex/OrderService.getFasterDelivery";
import CreateLivraison from "@salesforce/apex/OrderService.CreateLivraison";
import getOtherTransporteur from "@salesforce/apex/OrderService.getOtherTransporteur";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { RefreshEvent } from "lightning/refresh";
import { refreshApex } from '@salesforce/apex';
import hasAccessUI from '@salesforce/customPermission/customPermissionDelivery';




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
    @track conditionMet ; 


    get checkOrder() {        
        return this.conditionMet;
    }


      
        @wire(getcheckOrder, { ordID: "$recordId" })
        wiredCondition({ error, data }) {
            if (typeof this.recordId === "undefined" || this.recordId === undefined)
                {                  
                    return;
                }
            console.log('Order reçu : ' +  this.recordId);
            console.log("Données reçues :", JSON.stringify(data, null, 2));
            if (data) {
                console.log("Données reçues :", JSON.stringify(data, null, 2));
                this.conditionMet = data; // Mise à jour de la variable avec le booléen retourné
            } else if (error) {
                console.error("Erreur dans wiredCondition :", error);
            }
        }
    

   

    get isAccessible(){
        return hasAccessUI;
    }

    //le moins cher
    @wire(getBestPrice, { orderId: "$recordId" })
    wiredBestPrice(result) 
    {
        //console.log('Order reçu : ' +  this.recordId);
        //console.log("OrderId=" + this.recordId);
        //this.wiredBestPriceResult = result; // Stocke le résultat    
        this.orderId=  this.recordId;
        const { data, error } = result;
        /*console.log("Contenu de data BestPrice:", JSON.stringify(data, null, 2)); // Affiche tout le contenu de data
        console.log("Contenu de result BestPrice:", JSON.stringify(result, null, 2)); // Affiche tout le contenu de data*/
        if (data) {
            //console.log("OrderId=" + data.Id);
            //console.log("DelaiDeLivraisonJours__c=" + data.DelaiDeLivraisonJours__c);
            //console.log("tarif__c=" + data.Tarif__c);
            //console.log("Nom Transporteur=" + data.TransporteurID__r.Name);
            //this.TransportListItem=data;
            this.bestPriceTransporteurName = data.TransporteurID__r ? data.TransporteurID__r.Name : 'Nom non disponible';
            this.bestPriceDelaiLivraison = data.DelaiDeLivraisonJours__c ? data.DelaiDeLivraisonJours__c : 'Nom non disponible';
            this.bestPriceTarif = data.Tarif__c ? data.Tarif__c : 'Nom non disponible';
            this.bestPriceTransporteurCountry= data.Pays__c ? data.Pays__c : 'Nom non disponible';
            this.bestPriceId= data.Id ? data.Id : 'Nom non disponible';
            this.bestPriceTransporteurId= data.TransporteurID__c ? data.TransporteurID__c : 'Nom non disponible';
            }
            else if (error) {
                console.log("Erreur =" + error);
            }
    }

    //le plus rapide
    @wire(getFasterDelivery, { orderId: "$recordId" })
    wiredFasterDelivery(result) 
    {
        //console.log('OrderId reçu : ' +  this.recordId);
        this.orderId=  this.recordId;
        //console.log("orderIdId=" + this.recordId);
        //this.wiredBestPriceResult = result; // Stocke le résultat      
        const { data, error } = result;
        /*console.log("Contenu de data Faster :", JSON.stringify(data, null, 2)); // Affiche tout le contenu de data
        console.log("Contenu de result Faster :", JSON.stringify(result, null, 2)); // Affiche tout le contenu de data*/
        if (data) {
            //console.log("OrderId=" + data.Id);
            //console.log("FasterDeliveryDelaiDeLivraisonJours__c=" + data.DelaiDeLivraisonJours__c);
            //console.log("FasterDeliverytarif__c=" + data.Tarif__c);
            //console.log("FasterDeliveryNom Transporteur=" + data.TransporteurID__r.Name);
            //this.TransportListItem=data;
            this.FasterDeliveryTransporteurName = data.TransporteurID__r ? data.TransporteurID__r.Name : 'Nom non disponible';
            this.FasterDeliveryDelaiLivraison = data.DelaiDeLivraisonJours__c ? data.DelaiDeLivraisonJours__c : 'Nom non disponible';
            this.FasterDeliveryTarif = data.Tarif__c ? data.Tarif__c : 'Nom non disponible';
            this.FasterDeliveryCountry = data.Pays__c ? data.Pays__c : 'Nom non disponible';
            this.FasterDeliveryPriceId= data.Id ? data.Id : 'Nom non disponible';
            this.FasterDeliveryTransporteurId= data.TransporteurID__c ? data.TransporteurID__c : 'Nom non disponible';
            }
            else if (error) {
                console.log("Erreur =" + error);
            }
    }

    //tous les autres
    @wire(getOtherTransporteur, { orderId: "$recordId" })
    wiredOtherTransporteur(result) 
    {
        //console.log('OrderId reçu : ' +  this.recordId);
        this.orderId=  this.recordId;
        //console.log("orderIdId=" + this.recordId);
        //this.wiredBestPriceResult = result; // Stocke le résultat      
        const { data, error } = result;
         //console.log("getOtherTransporteur data:", JSON.stringify(data, null, 2)); // Affiche tout le contenu de data
        if (data) {

            try {
                if (data) {

                    const FasterDeliveryTransporteurName = this.FasterDeliveryTransporteurName;  // Transporteur le plus rapide
                    const bestPriceTransporteurName = this.bestPriceTransporteurName;  // Transporteur le moins cher
                    //console.log("FasterDeliveryTransporteurName:", FasterDeliveryTransporteurName);
                    //console.log("bestPriceTransporteurName:", bestPriceTransporteurName);
                    this.Othertransporteurs = data.filter(transporteur => {
                        //console.log('Transporteur en cours:', transporteur.TransporteurID__r.Name);
                        return transporteur.TransporteurID__r.Name !== FasterDeliveryTransporteurName &&
                               transporteur.TransporteurID__r.Name !== bestPriceTransporteurName;
                    });
                    
                    //console.log("getOtherTransporteur result:", JSON.stringify(result, null, 2)); // Affiche tout le contenu de dataporteurs = data;
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
   // console.log("radioButton =", JSON.stringify(radioButton, null, 2));
    // Si le bouton radio existe, déclenche son événement onchange
    if (radioButton) {
        radioButton.checked = true; // Coche le bouton radio
        this.handleShippingChange({ target: radioButton }); // Déclenche l'événement onchange
    }
}

    handleShippingChange(event) {
       try
       {
         const selectedValue = event.target.value; // Récupère la valeur du bouton radio sélectionné
         //console.log("event.target =", JSON.stringify(event.target, null, 2));
        //console.log('Type Transport sélectionné : ', selectedValue);
        this.transporteurName = event.target.dataset.transporteur;
        //console.log("transporteurName : " + this.transporteurName);
       this.priceid=event.target.dataset.priceid;
       //console.log("priceid : " + this.priceid);
         this.transporteurid = event.target.dataset.transporteurid;
         //console.log("transporteurid : " + this.transporteurid);
         this.OptionShipping=selectedValue;
         //console.log("OptionShipping : " + this.OptionShipping);
        
       
        //actionName=selectedValue;
       /* if (selectedValue === "cheapest") {
            this.OptionShipping="cheapest";         
        } 
        else if (selectedValue === "fastest") {
            this.OptionShipping="fastest";
        }
        else if (selectedValue === "other") {
            this.OptionShipping="Autrre Option de livraison";
        }
        console.log("OptionShipping : " + this.OptionShipping);*/
       }
       catch(error)
       {
        console.error('Une erreur est survenue :', error.message);
       }
       
      }

      handleChooseShipping(event) {
       try
       { 
        if (typeof this.transporteurName === "undefined" || this.transporteurName === undefined)
                    {
                        this.showToast("Erreur", "Vous devez choisir au moins un mode de livraison", "error");
                        return;
                    }
            // Récupérer des données depuis l'attribut dataset du bouton
                    //console.log("je demarre la selection de la livraison.... " );
                    //const transportId = event.target.dataset.transportId;
                    //console.log('Livraison choisie pour le transporteur ID :', transportId);
                    //console.log('OrderId= :', this.orderId);
                   //console.log("OptionShipping: " + this.OptionShipping);
                   //console.log("transporteurName= : " + this.transporteurName);
                   //console.log("transporteurid= : " + this.transporteurid);
                    // Effectuer une action, comme stocker l'ID dans une propriété
                    //this.selectedTransportId = transportId;
                    
                   
                    CreateLivraison({ 
                        Status: 'en cours', 
                        OrderId: this.orderId, 
                        shippingOption: this.OptionShipping ,
                        TransporteurName: this.transporteurName ,
                        transporteurid:this.transporteurid
                    })
                    .then(() => {
                        console.log('Livraison créée avec succès.');
                        // Ajoutez ici toute logique supplémentaire après un succès
                    })
                    .catch(error => {
                        console.error('Erreur lors de la création de la livraison :', error);
                        // Gérez l'erreur, par exemple en affichant un message utilisateur
                    });
                    // Vous pouvez aussi appeler une méthode Apex ou déclencher un autre événement ici
                    this.showToast("Info", "L expedition vient d etre effectué", "success");
                    this.dispatchEvent(new RefreshEvent());
                 
       }
       catch(error)
       {
        console.error('Une erreur est survenue :', error.message);
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
