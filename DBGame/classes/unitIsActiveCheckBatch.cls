global class unitIsActiveCheckBatch implements Database.Batchable<sObject>
{
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator([SELECT ID, Active__c, Deactivation_Time__c
                                      FROM Unit__c]);
   }

   global void execute(Database.BatchableContext BC, List<Unit__c> scope)
   {
       List<Unit__c> updateUnitList = new List<Unit__c>();
       for(Unit__c item :(List<Unit__c>) scope)
       {
           if (item.Deactivation_Time__c < DateTime.now().addDays(-1)) 
           {
                item.Active__c = true;
           }
       }
       update updateUnitList;
   }

   global void finish(Database.BatchableContext BC) 
   {
       System.scheduleBatch(new unitIsActiveCheckBatch(), 'Unit activity check batch', 360);
   }
    
}