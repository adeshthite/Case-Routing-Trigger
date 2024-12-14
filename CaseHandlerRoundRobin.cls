trigger CaseRoundRobinTrigger on Case (before insert) {
    
    if(Trigger.isbefore && Trigger.isinsert){
        CaseHandlerRoundRobin.assignCasesUser(Trigger.new);
    }

/*   ApexClass   */
public class CaseHandlerRoundRobin {

    public static void assignCasesUser(List<Case> caselist) {
       
         List<Case_Routing__c> routingRecords = [SELECT Id, User__c,Assigned_Count__c, Last_Assigned__c FROM Case_Routing__c WHERE Active__c = TRUE ORDER BY Last_Assigned__c ASC ];
        
        System.debug('routing Records'+routingRecords);

      
    Integer routIndex = 0;

    for (Case c : caselist) {
        c.OwnerId = routingRecords[routIndex].User__c;
        
        System.debug('Assigning Case' + c.Id + ' touser' + routingRecords[routIndex].User__c);


        routingRecords[routIndex].Last_Assigned__c = System.now();
        
        if (routingRecords[routIndex].Assigned_Count__c == null) {
            routingRecords[routIndex].Assigned_Count__c = 1;
            
        } else {
            routingRecords[routIndex].Assigned_Count__c++;
        }


        routIndex++;

        if (routIndex >= routingRecords.size()) {
            routIndex = 0;
        }
    }
     System.debug('Routing Records After Assignment ' + routingRecords);


    update routingRecords;
    }
}
