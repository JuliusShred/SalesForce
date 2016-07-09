/**
* this is the AccountCheckerController class for our game witch helps to interact with VF page
* it has wrapper class which helps to operate with checkbox values so we can check the accounts that we want to display
*/
public class AccountCheckerController
{  
    public List<AccountWrapper> accWrapper{get; set;}  
    public List<Account> checkedAccs {get; set;}
   
    public AccountCheckerController()
    {  
        accWrapper = getData();  
    }  
    //it works when we clicking checkon VF page
    public void checkedRecords()
    {  
        checkedAccs = new List<Account>();  
        for(AccountWrapper acc : accWrapper)
        {  
            if(acc.isSelected)
            {  
                checkedAccs.add(acc.myAccount);  
            }  
        }  
        accWrapper = getData(); 
    }  
    //this parts retrieves data from accounts
    public List<AccountWrapper> getData()
    {  
        List<Account> accList = [SELECT Name,Id,Phone, Description FROM Account];        
        List<AccountWrapper> accWrapper = new List<AccountWrapper>();  
        for(Account acc : accList)
        {   
            accWrapper.add(new AccountWrapper(acc,false));  
        }  
        return accWrapper;  
    }  
    //wrapper class
    public class AccountWrapper
    {  
        public boolean isSelected {get; set;}  
        public Account myAccount {get; set;}  
    
        public AccountWrapper(Account myAccount,Boolean isSelected)
        {  
            this.myAccount = myAccount;  
            this.isSelected = isSelected;  
        }  
    }  
}