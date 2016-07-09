public class  WorkPeriodsController{

    public List<Work_Period__c> workPeriods {set; get;}
    public List<String> companies {set; get;}

    public WorkPeriodsController()
    {
        workPeriods = [SELECT Id, Name, Order__r.Name, Order__r.Account__r.Name,Rate__r.Name,Rate__r.Customer_rate__c, Rate__r.Employer_rate__c
                       FROM Work_Period__c];
        companies = new List<String>();
        for(Work_Period__c wp: workPeriods)
        {
            companies.add(wp.Order__r.Account__r.Name);
        }
    }
}