@isTest
public class GameTest {
    
    @isTest static void unitTest ()
    {

    }
	@isTest static void gameTest ()
    {
        Unit__c winner = new Unit__c();
        Unit__c firstUnit = new Unit__c(Name = 'first', HP__c = 200, minDMG__c = 10, maxDMG__c = 20);
        Unit__c secondUnit = new Unit__c(Name = 'second', HP__c = 200, minDMG__c = 10, maxDMG__c = 20);
        Game g = new Game();
        
        
        for(Integer i = 0; i < 20; i++)
        {
            winner = g.fight(firstUnit, secondUnit);
        }

        
        System.assertEquals(true, winner == firstUnit || winner == secondUnit);
    }	
}