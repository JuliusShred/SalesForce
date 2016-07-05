global class staminaRecoveryBatch implements Database.Batchable<sObject>
{
   global Database.QueryLocator start(Database.BatchableContext BC)
   {
      return Database.getQueryLocator([SELECT ID, Stamina__c
                                      FROM Unit__c]);
   }

   global void execute(Database.BatchableContext BC, List<Unit__c> scope)
   {
       List<Unit__c> updateUnitList = new List<Unit__c>();
       for(Unit__c item :(List<Unit__c>) scope)
       {
           if (item.Stamina__c + 10 <= 100) 
           {
                item.Stamina__c += 10;
           } else
           {
               item.Stamina__c = 100;
           }
           updateUnitList.add(item);
       }
       update updateUnitList;
   }

   global void finish(Database.BatchableContext BC) 
   {

   }

}