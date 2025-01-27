trigger OrderTrigger on Order (before update) {

  
   try {
            new OrderService().validateOrder( Trigger.newMap.keySet(), Trigger.newMap);
        } catch (OrderService.OrderValidationException e) {
            // Ajout de l'erreur à l'objet Order
            for (Order order : Trigger.new) {
                order.addError(e.getMessage());
            }
        }
   
    
}