public with sharing class OpportunityLineItemSelector {
    public static List<OpportunityLineItem> getNumberOfProduct(Id OpportunityId)
        {
          
            List<OpportunityLineItem> OpportunitiesListItem =  [ SELECT TotalPrice FROM OpportunityLineItem WHERE OpportunityId = :OpportunityId ];
                   return  OpportunitiesListItem;
           
        }

}