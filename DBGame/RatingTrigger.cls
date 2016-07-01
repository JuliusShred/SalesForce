trigger RatingTrigger on Unit__c (before update) 
{   
    Map<Id, Unit__c> unitsOld = Trigger.oldMap;
    Map<Id, Unit__c> unitsNew = Trigger.newMap;
    
	Integer unitsWithChangedNumberOfVictories = 0;
    for (Unit__c unit: Trigger.new)
    {
        if (unitsOld.get(unit.Id).Number_of_victories__c != unitsNew.get(unit.Id).Number_of_victories__c)
        {
            unitsWithChangedNumberOfVictories++;
        }
    }
    
    if (unitsWithChangedNumberOfVictories > 0)
    {
        List<Unit__c> otherUnits = [SELECT Id, Number_of_victories__c, Position_in_top__c
                                    FROM Unit__c
                                    WHERE Id NOT IN :Trigger.new];
        List<Unit__c> newUnits = Trigger.new;
        List<Unit__c> allUnits = new List<Unit__c>();
        allUnits.addAll(newUnits);
        allUnits.addAll(otherUnits);
        List<UnitSorter> unitSorter = new List<UnitSorter>();
        
        for (Unit__c unit: allUnits) 
        {
            UnitSorter sorter = new UnitSorter();
            sorter.unit = unit;
            unitSorter.add(sorter);
        }
        unitSorter.sort();
        
        List<Fight__c> fights = [SELECT Winner__c, Looser__c
                                 FROM Fight__c];
        Map<Id, Integer> unitsFights = new Map<Id, Integer>();
        
        for (Fight__c fight: fights)
        {
            if (unitsFights.containsKey(fight.Winner__c)) 
            {
                unitsFights.put(fight.Winner__c, unitsFights.get(fight.Winner__c) + 1);
            } else 
            {
                unitsFights.put(fight.Winner__c, 1);
            }
            if (unitsFights.containsKey(fight.Looser__c)) 
            {
                unitsFights.put(fight.Looser__c, unitsFights.get(fight.Looser__c) + 1);
            } else 
            {
                unitsFights.put(fight.Looser__c, 1);
            }
        }
        List<Unit__c> unitsToUpdate = new List<Unit__c>();
        Integer PositionInTop = 0;
        for (UnitSorter sorter: unitSorter)
        {
            PositionInTop++;
            Unit__c unit = sorter.unit;
            unit.Position_in_top__c = PositionInTop;
            Integer allUnitsFights = 1;
            if (unitsFights.containsKey(unit.Id))
            {
                allUnitsFights = unitsFights.get(unit.Id);
            }
            unit.Percent_of_Victories__c = (unit.Number_of_victories__c / allUnitsFights) * 100;
            if (!(unitsNew.containsKey(unit.Id)))
            {
                unitsToUpdate.add(unit);
            }
        }
        update unitsToUpdate;
    }
}