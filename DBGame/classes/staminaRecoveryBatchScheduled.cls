global class staminaRecoveryBatchScheduled implements Schedulable 
{
	global void execute(SchedulableContext sc) 
	{
		database.executeBatch(new staminaRecoveryBatch(), 1);
	}
}