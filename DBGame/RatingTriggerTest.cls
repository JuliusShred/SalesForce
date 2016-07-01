@isTest
public class RatingTriggerTest {

    @isTest static void RatingTriggerTest ()
    {
        Unit__c unit1 = new Unit__c(Name = 'Unit1', HP__c = 100, minDMG__c = 5, maxDMG__c = 10, Number_of_Victories__c = 0);
        Unit__c unit2 = new Unit__c(Name = 'Unit2', HP__c = 100, minDMG__c = 5, maxDMG__c = 10, Number_of_Victories__c = 0);
        Unit__c unit3 = new Unit__c(Name = 'Unit3', HP__c = 100, minDMG__c = 5, maxDMG__c = 10, Number_of_Victories__c = 0);
        Fight__c fight1 = new Fight__c(Winner__c = unit1.Id, Looser__c = unit2.Id);
        Fight__c fight2 = new Fight__c(Winner__c = unit3.Id, Looser__c = unit1.Id);
        Fight__c fight3 = new Fight__c(Winner__c = unit2.Id, Looser__c = unit3.Id);
        Fight__c fight4 = new Fight__c(Winner__c = unit3.Id, Looser__c = unit1.Id);
        Fight__c fight5 = new Fight__c(Winner__c = unit3.Id, Looser__c = unit1.Id);

        List<Unit__c> units = new List<Unit__c>();
        units.add(unit1);
        units.add(unit2);
        units.add(unit3);
        List<Fight__c> fights = new List<Fight__c>();
        fights.add(fight1);
        fights.add(fight2);
        fights.add(fight3);
        fights.add(fight4);
        fights.add(fight5);
        
        insert units;
        insert fights;

        unit1.Number_of_Victories__c = 1;
        unit2.Number_of_Victories__c = 2;
        unit3.Number_of_Victories__c = 3;
        update units;
        
        List<Unit__c> unitsAfterTest = [SELECT Id, Name, Position_in_Top__c, Number_of_Victories__c, Percent_of_Victories__c
                                        FROM Unit__c
                                        WHERE Id IN (:unit1.Id, :unit2.Id, :unit3.Id)
                                        ORDER BY Id];
        
        System.assertEquals(3, unitsAfterTest.get(0).Position_in_Top__c);
        System.assertEquals(2, unitsAfterTest.get(1).Position_in_Top__c);
        System.assertEquals(1, unitsAfterTest.get(2).Position_in_Top__c);
        
        //need to deal with troubles below
        //System.assertEquals(25, unitsAfterTest.get(0).Percent_of_Victories__c);
        //System.assertEquals(50, unitsAfterTest.get(1).Percent_of_Victories__c);
        //System.assertEquals(75, unitsAfterTest.get(2).Percent_of_Victories__c);

    }
}