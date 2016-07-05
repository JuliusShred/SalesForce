public class GameController 
{
    public Boolean showCreateUnit {get; set;}
    public Boolean showFirstChosenUnit {get; set;}
    public Boolean showSecondChosenUnit {get; set;}
    public Boolean showResult {get; set;}
    public Unit__c firstUnit {get; set;}
    public Unit__c secondUnit {get; set;}
    public Unit__c winner {get; set;}
    public Unit__c newUnit {get; set;}
    public List<Unit__c> activeUnits {get; set;}
    public List<Unit__c> allUnits {get; set;}
    public String firstChosedUnit {get; set;}
    public String secondChosedUnit {get; set;}
    public Game game {get; set;}

    public void GameInit () 
    {
        newUnit = new Unit__c();
        firstUnit = new Unit__c();
        secondUnit = new Unit__c();
        getActiveUnits();
        getAllUnits();
        checkUnitsActivity();
        showFirstChosenUnit = false;
        showSecondChosenUnit = false;
        showResult = false;
        showCreateUnit = false;
    }
    
    private void getActiveUnits() 
    {
        activeUnits = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Number_of_victories__c, Position_in_top__c, Percent_of_Victories__c, Stamina__c
                       FROM Unit__c 
                       WHERE Active__c = true];
    }
    
    private void getAllUnits() 
    {
        allUnits = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Number_of_victories__c, Position_in_top__c, Percent_of_Victories__c, Stamina__c
                    FROM Unit__c];
    }
    
    private void checkUnitsActivity() 
    {
        List<Unit__c> unitsToCheckList = [SELECT Active__c, Deactivation_Time__c 
                                          FROM Unit__c 
                                          WHERE Active__c = false];
        
        List<Unit__c> unitsToUpdateList = new List<Unit__c>();
        for (Unit__c unit: unitsToCheckList)
        {
            if (unit.Deactivation_Time__c < DateTime.now().addDays(-1)) 
            {
                unit.Active__c = true;
                unitsToUpdateList.add(unit);
            }
        }
        if (!unitsToUpdateList.isEmpty())
        {
            update unitsToUpdateList;
        }
    }
 
    public PageReference fight() 
    {
        winner = new Unit__c();
        Unit__c looser = new Unit__c();
        game = new Game();
        winner = game.fight(firstUnit, secondUnit);
        if (winner == firstUnit)
        {
            winner = firstUnit;
            looser = secondUnit;
            secondUnit = null;
            showSecondChosenUnit = false;
        }
        else
        {
            winner = secondUnit;
            looser = firstUnit;
            firstUnit = null;
            showFirstChosenUnit = false;           
        }
        showResult = true;
        deactivateUnits(winner, looser);
        saveGameResult(winner,  looser);
        getAllUnits();
        getActiveUnits();
        return null;
    }
    
    private void saveGameResult(Unit__c winner, Unit__c looser) 
    {
        String gameLogString = '';
        for (String str: game.gameLog) 
        {
            gameLogString = gameLogString + str + '\n';
        }
        Fight__c fight = new Fight__c(Name = winner.Name + ' vs. ' + looser.Name, 
                                      Winner__c = winner.Id, 
                                      Looser__c = looser.Id, 
                                      Date__c = DateTime.now(),
                                      Game_Log__c = gameLogString);
        
        insert fight;
        winner.Number_of_Victories__c ++;
        update winner;
    }
    
    private void deactivateUnits(Unit__c winner, Unit__c looser) 
    {
        if (winner.Stamina__c == 0)
        {
            winner.Active__c= false;
            update winner;
        }
        looser.Active__c = false;
        looser.Deactivation_Time__c = DateTime.now();
        update looser;
    }
    
    public PageReference createUnit ()
    {
        showCreateUnit = true;
        return null;
    }
    public PageReference cancelCreation()
    {
        showCreateUnit = false;
        return null;
    }
    public PageReference saveUnit ()
    {
        if (newUnit.Name != null && newUnit.HP__c > 0 && newUnit.maxDMG__c > 0 && (newUnit.minDMG__c > 0 && newUnit.minDMG__c < newUnit.maxDMG__c))
        {
            insert newUnit;
        }
        else ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                            'Enter proper values'));
        showCreateUnit = false;
        getAllUnits();
        getActiveUnits();
        return null;
    }
    
    public PageReference chooseFirstUnit() 
    {
        firstUnit = chooseUnit(firstUnit, firstChosedUnit);
        showFirstChosenUnit = true;
        return null;
    }
    
    public PageReference chooseSecondUnit() 
    {
        secondUnit = chooseUnit(secondUnit, secondChosedUnit);
        showSecondChosenUnit = true;
        return null;
    }
    
    private Unit__c chooseUnit(Unit__c chosingUnit, String chosedUnit) 
    {
        if (chosedUnit!='' && chosedUnit!='Select Unit' && chosedUnit!='Not available') 
        {
            for (Unit__c unit: activeUnits) 
            {
                if (unit.Id.equals(chosedUnit)) 
                {
                    chosingUnit = unit;
                }
            }       
        } 
        return chosingUnit;
    }
    
    public List<SelectOption> getUnitSelectList() 
    {
        List<SelectOption> options = new List<SelectOption>();

        List<Unit__c> listOfUnits = new List<Unit__c>();
        for (Unit__c unit: activeUnits) 
        {
            if (unit != firstUnit && unit != secondUnit) 
            {   
                listOfUnits.add(unit);
            }
        }

        for (Unit__c unit : listOfUnits) 
        {
            String unitString = unit.Name + ': HP=' + unit.HP__c + ', Minimal damage = ' + unit.minDMG__c + ', Maximum damage = ' + unit.maxDMG__c ;
            options.add(new SelectOption(unit.Id, unitString));
        }

        if (options.size() > 0) 
        {
            options.add(0, new SelectOption('', 'Select Unit'));
        } else 
        {
            options.add(new SelectOption('', 'Not available'));
        }
        return options;
    }
    
    public PageReference activateAllUnits ()
    {
        List<Unit__c> inActiveUnitsList = [SELECT  Active__c, Deactivation_Time__c
                                           FROM Unit__c
                                           WHERE Active__c = false];
        for (Unit__c unit: inActiveUnitsList) 
        {
            unit.Active__c = true;
        }
        update inActiveUnitsList;
        getActiveUnits();
        getAllUnits();
        showFirstChosenUnit = false;
        showSecondChosenUnit = false;
        return null;
    }  
}