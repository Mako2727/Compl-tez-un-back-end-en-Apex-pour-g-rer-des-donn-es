import { LightningElement, api, wire, track } from "lwc";
import getBestPrice from "@salesforce/apex/OrderService.getBestPrice";
import getFasterDelivery from "@salesforce/apex/OrderService.getFasterDelivery";
import CreateLivraison from "@salesforce/apex/OrderService.CreateLivraison";



export default class shippingViewer extends LightningElement {

    @api recordId;
    @track error = {};
    wiredBestPriceResult;
    @track TransportListItem;
    @track bestPriceTransporteurName;
    @track bestPriceDelaiLivraison;
    @track bestPriceTarif;


    @track FasterDeliveryTransporteurName;
    @track FasterDeliveryDelaiLivraison;
    @track FasterDeliveryTarif;
    @track OptionShipping;
    @track OpportunityId;

    @wire(getBestPrice, { opportunityId: "$recordId" })
    wiredBestPrice(result) 
    {
        //console.log('OpportunityId reçu : ' +  this.recordId);
        //console.log("OpportunityId=" + this.recordId);
        //this.wiredBestPriceResult = result; // Stocke le résultat    
        this.OpportunityId=  this.recordId;
        const { data, error } = result;
        console.log("Contenu de data :", JSON.stringify(data, null, 2)); // Affiche tout le contenu de data
        console.log("Contenu de result :", JSON.stringify(result, null, 2)); // Affiche tout le contenu de data
        if (data) {
            console.log("OpportunityId=" + data.Id);
            console.log("DelaiDeLivraisonJours__c=" + data.DelaiDeLivraisonJours__c);
            console.log("tarif__c=" + data.Tarif__c);
            console.log("Nom Transporteur=" + data.TransporteurID__r.Name);
            //this.TransportListItem=data;
            this.bestPriceTransporteurName = data.TransporteurID__r ? data.TransporteurID__r.Name : 'Nom non disponible';
            this.bestPriceDelaiLivraison = data.DelaiDeLivraisonJours__c ? data.DelaiDeLivraisonJours__c : 'Nom non disponible';
            this.bestPriceTarif = data.Tarif__c ? data.Tarif__c : 'Nom non disponible';
            }
            else if (error) {
                console.log("Erreur =" + error);
            }
    }


    @wire(getFasterDelivery, { opportunityId: "$recordId" })
    wiredFasterDelivery(result) 
    {
        //console.log('OpportunityId reçu : ' +  this.recordId);
        this.OpportunityId=  this.recordId;
        //console.log("OpportunityId=" + this.recordId);
        //this.wiredBestPriceResult = result; // Stocke le résultat      
        const { data, error } = result;
        console.log("Contenu de data :", JSON.stringify(data, null, 2)); // Affiche tout le contenu de data
        console.log("Contenu de result :", JSON.stringify(result, null, 2)); // Affiche tout le contenu de data
        if (data) {
            console.log("OpportunityId=" + data.Id);
            console.log("FasterDeliveryDelaiDeLivraisonJours__c=" + data.DelaiDeLivraisonJours__c);
            console.log("FasterDeliverytarif__c=" + data.Tarif__c);
            console.log("FasterDeliveryNom Transporteur=" + data.TransporteurID__r.Name);
            //this.TransportListItem=data;
            this.FasterDeliveryTransporteurName = data.TransporteurID__r ? data.TransporteurID__r.Name : 'Nom non disponible';
            this.FasterDeliveryDelaiLivraison = data.DelaiDeLivraisonJours__c ? data.DelaiDeLivraisonJours__c : 'Nom non disponible';
            this.FasterDeliveryTarif = data.Tarif__c ? data.Tarif__c : 'Nom non disponible';
            }
            else if (error) {
                console.log("Erreur =" + error);
            }
    }

    handleShippingChange(event) {
       try
       {
         const selectedValue = event.target.value; // Récupère la valeur du bouton radio sélectionné
        console.log('Transport sélectionné : ', selectedValue);
        //console.log("actionName : " + actionName);
        //actionName=selectedValue;
        if (selectedValue === "cheapest") {
            this.OptionShipping="cheapest";         
        } else if (selectedValue === "fastest") {
            this.OptionShipping="fastest";
        }
        console.log("OptionShipping : " + this.OptionShipping);
       }
       catch(error)
       {
        console.error('Une erreur est survenue :', error.message);
       }
       
      }

      handleChooseShipping(event) {
       try
       {
            // Récupérer des données depuis l'attribut dataset du bouton
                    console.log("je demarre la selection de la livraison.... " );
                    //const transportId = event.target.dataset.transportId;
                    //console.log('Livraison choisie pour le transporteur ID :', transportId);
                    console.log('OpportunityId= :', this.OpportunityId);
                   console.log("je créé la livraison : " + this.OptionShipping);
                    // Effectuer une action, comme stocker l'ID dans une propriété
                    //this.selectedTransportId = transportId;
                    
                    CreateLivraison({ 
                        Status: 'en cours', 
                        OpportunityId: this.OpportunityId, 
                        shippingOption: this.OptionShipping 
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
                 
       }
       catch(error)
       {
        console.error('Une erreur est survenue :', error.message);
       }
       

    }


}
