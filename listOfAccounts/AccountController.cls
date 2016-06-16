public class AccountController
{  
   public List<sObjectWrapper> wrappers{get; set;}  
   public List<Account> checkedAccs {get; set;}
   
   public AccountController()
   {  
     wrappers = getData();  
   }  
   
   public PageReference checkedRecords()
   {  
     checkedAccs = new List<Account>();  
     for(sObjectWrapper wrap : wrappers)
     {  
       if(wrap.isSelected)
       {  
         checkedAccs.add(wrap.myAccount);  
       }  
     }  
     wrappers = getData(); 
     return null;
   }  
   
   private List<sObjectWrapper> getData()
   {  
     List<sObjectWrapper> wrappers = new List<sObjectWrapper>();  
     for(Account acc : [SELECT Name,Id,Phone, Description FROM Account])
     {  
       wrappers.add(new sObjectWrapper(acc,false));  
     }  
     return wrappers;  
   }  
   
   public class sObjectWrapper
   {  
    public boolean isSelected {get; set;}  
    public Account myAccount {get; set;}  
    
    public sObjectWrapper(Account myAccount,Boolean isSelected)
    {  
     this.myAccount = myAccount;  
     this.isSelected = isSelected;  
    }  
   }  
 }