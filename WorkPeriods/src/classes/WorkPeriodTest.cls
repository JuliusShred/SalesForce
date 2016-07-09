@isTest
public class WorkPeriodTest 
{
	@isTest static void  WorkPeriodTest() 
	{
		List<Work_Period__c> workPeriods = new List<Work_Period__c>();
        List<String> companies = new List<String>();
        
		workPeriods = [SELECT Id, Name, Order__r.Name, Order__r.Account__r.Name,Rate__r.Name,Rate__r.Customer_rate__c, Rate__r.Employer_rate__c
                       FROM Work_Period__c];
        
		WorkPeriodsController wpc = new WorkPeriodsController();
        for(Work_Period__c wp: workPeriods)
        {
            companies.add(wp.Order__r.Account__r.Name);
        }
        
		system.assert(workPeriods.size() == wpc.workPeriods.size());
        system.assert(companies.size() == wpc.companies.size());
	}
}