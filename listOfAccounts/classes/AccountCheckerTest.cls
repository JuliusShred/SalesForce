@isTest
public class AccountCheckerTest 
{
	@isTest static void AccountCheckerTest() 
    {
        AccountCheckerController accCtrl = new AccountCheckerController();
        
        List<AccountCheckerController.AccountWrapper> accWrapper = new List<AccountCheckerController.AccountWrapper>();
        List<Account> accountsList = new List<Account>();
        accountsList = [SELECT Id,Name, Phone, Description FROM Account];
        for(Account acc : accountsList)
        {  
            accWrapper.add(new AccountCheckerController.AccountWrapper(acc,false));  
        }
        accCtrl.accWrapper = accCtrl.getData();
        accCtrl.checkedRecords();
        
        system.assert(accWrapper.size() == accCtrl.accWrapper.size());     
        
        List<Account> checkedAccs = new List<Account>();
        for(AccountCheckerController.AccountWrapper acc : accWrapper)
        {  
            if(acc.isSelected)
            {  
                checkedAccs.add(acc.myAccount);  
            }  
        }        
        system.assert(checkedAccs.size() == accCtrl.checkedAccs.size());
    }
}