global class unitIsActiveCheckBatchScheduled implements Schedulable 
{
    global void execute(SchedulableContext sc) 
    {
        database.executebatch(new staminaRecoveryBatch(), 1);
    }
}