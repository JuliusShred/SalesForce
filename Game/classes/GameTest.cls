@isTest
public class GameTest {
    /**
    * in gameTest() method we are going to test the game logic
    */
    @isTest static void gameTest()
    {
        Unit__c winner = new Unit__c();
        Unit__c firstUnit = new Unit__c(Name = 'first', HP__c = 200, minDMG__c = 10, maxDMG__c = 29, Stamina__c = 100);
        Unit__c secondUnit = new Unit__c(Name = 'second', HP__c = 200, minDMG__c = 30, maxDMG__c = 49, Stamina__c = 100);
        Game g = new Game();
        //testing the values that getBlockKickType() method have to return
        String  HeadType =  g.getBlockKickType(0);
        String  ChestType =  g.getBlockKickType(1);
        String  BellyType =  g.getBlockKickType(2);
        String  GroinType =  g.getBlockKickType(3);
        
        System.assertEquals('Head', HeadType);
        System.assertEquals('Chest', ChestType);
        System.assertEquals('Belly', BellyType);
        System.assertEquals('Groin', GroinType);
        //spentStaminaPoints values testing for spentStaminaPoints() method
        List <Decimal> spentStaminaPointsValuesList = new List <Decimal>();
        
        for(Integer i = 0; i < 20; i++)
        {
            spentStaminaPointsValuesList.add(g.spentStaminaPoints(i*10));
        }
        
        System.assertEquals(spentStaminaPointsValuesList.size(), 20);
        Integer counter = 0;
        for(Decimal i: spentStaminaPointsValuesList){
            System.assert(i == counter);
            counter++;
            System.assertNotEquals(null, i);
            System.debug(i);
        }
        //damage values testing for generateDamage() method
        List <Integer> firstUnitDamageValuesList = new List <Integer>();
        List <Integer> secondUnitDamageValuesList = new List <Integer>();
        
        for(Integer i = 0; i < 20; i++)
        {
            firstUnitDamageValuesList.add(g.generateDamage(firstUnit));
            secondUnitDamageValuesList.add(g.generateDamage(secondUnit));
        }

        System.assertEquals(firstUnitDamageValuesList.size(), 20);
        System.assertEquals(secondUnitDamageValuesList.size(), 20);
        
        for(Integer i: firstUnitDamageValuesList){
            System.assert(i >= 10 && i <= 29);
            System.assertNotEquals(0, i);
            System.assertNotEquals(null, i);
            System.debug(i);
        }
        for(Integer i: secondUnitDamageValuesList){
            System.assert(i >= 30 && i <= 49);
            System.assertNotEquals(0, i);
            System.assertNotEquals(null, i);
            System.debug(i);
        }
        //testing winner results for fight() method
        List <Unit__c> winnerList = new List <Unit__c>();
        
        for(Integer i = 0; i < 10; i++)
        {
            winnerList.add(g.fight(firstUnit, secondUnit));
        }
        
        System.assertEquals(winnerList.size(), 10);
        
        for(Unit__c unit: winnerList){
            System.assert(unit == firstUnit || unit == secondUnit);
            System.debug(unit);
        }
        //damage values testing for hit() method
        List <Integer> firstUnitHitValuesList = new List <Integer>();
        List <Integer> secondUnitHitValuesList = new List <Integer>();
        
        for(Integer i = 0; i < 40; i++)
        {
            firstUnitHitValuesList.add(g.Hit(firstUnit, secondUnit));
            secondUnitHitValuesList.add(g.Hit(secondUnit, firstUnit));
        }

        System.assertEquals(firstUnitHitValuesList.size(), 40);
        System.assertEquals(secondUnitHitValuesList.size(), 40);
        
        for(Integer i: firstUnitHitValuesList){
            System.assert((i >= 10 && i <= 29) || i == 0);
            System.assertNotEquals(null, i);
            System.debug(i);
        }
        for(Integer i: secondUnitHitValuesList){
            System.assert((i >= 30 && i <= 49) || i == 0);
            System.assertNotEquals(null, i);
            System.debug(i);
        }        
        //testing the GameException
        String message;
        try
        {
            winner = g.fight(firstUnit, null);
        } 
        catch(GameException e)
        {
            message = e.getMessage();
        }
        System.assert(message == 'Unit cannot be null.');
    }   
    /**
    * in gameControllerTest() we need to test our Controller
    */
    @isTest static void gameControllerTest ()
    {
        //testing the initialization of data in controller
        GameController controller = new GameController();
        PageReference pageRef = Page.GamePage;
        Test.setCurrentPage(pageRef);
        
        controller.GameInit();
        List <Unit__c> activeUnits = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Number_of_victories__c, Number_of_Games__c, Position_in_top__c, Percent_of_Victories__c, Stamina__c
                                      FROM Unit__c
                                      WHERE Active__c = true];
        
        List <Unit__c> allUnits = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Number_of_victories__c, Number_of_Games__c, Position_in_top__c, Percent_of_Victories__c, Stamina__c
                                   FROM Unit__c];
        System.assert(allUnits.size() == controller.allUnits.size());
        System.assert(activeUnits.size() == controller.activeUnits.size());
        
        List<Unit__c> unitsToCheckList = [SELECT Active__c, Deactivation_Time__c, Stamina__c
                                          FROM Unit__c 
                                          WHERE Active__c = false];
        Unit__c longTimeAgoDeactivatedUnit = new Unit__c(name = 'old',  HP__c = 100, minDMG__c = 12, maxDMG__c = 15, Stamina__c = 20, Deactivation_Time__c = DateTime.now().addDays(-2), Active__c = false);
        insert longTimeAgoDeactivatedUnit;
        update longTimeAgoDeactivatedUnit;
        controller.checkUnitsActivity();
        
        longTimeAgoDeactivatedUnit.Active__c = false;
        update longTimeAgoDeactivatedUnit;
        controller.activateAllUnits();
        System.assert(controller.activeUnits.size() == controller.allUnits.size());
        //here is the test for our unit management methods
        controller.createEditUnit();
        System.assert(controller.showCreateEditUnit == true);
        System.assert(controller.isCreating == true);
        System.assert(controller.isUpdating == false);
        System.assert(controller.newUnit != null);
        
        controller.newUnit = new Unit__c();

        controller.saveUnit();
        System.assert(ApexPages.GetMessages().get(0).getSummary() == 'Make sure that you have entered the proper values.');
        
        controller.newUnit.Name = 'testUnitName';
        controller.newUnit.HP__c = 100;
        controller.newUnit.minDMG__c = 20;
        controller.newUnit.maxDMG__c = 10;
        controller.newUnit.Stamina__c = 20;
        
        controller.saveUnit();      
        System.assert(ApexPages.GetMessages().get(1).getSummary() == 'Minimum Damage cannot be less then Maximum Damage'); 
        
        controller.newUnit.minDMG__c = 10;
        controller.newUnit.maxDMG__c = 20;
        Unit__c testUnit = controller.newUnit;
        controller.saveUnit();       
        
        List <Unit__c> testUnitList = [SELECT Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c 
                                        FROM Unit__c 
                                        WHERE ID = :testUnit.ID];
        System.assert(testUnit.ID == testUnitList[0].ID);
        
        ApexPages.currentPage().getParameters().put('unitID' , controller.allUnits[0].ID);
        controller.editUnit();
        testUnit = controller.newUnit;
        System.assert(controller.allUnits[0].ID == testUnit.ID);
        System.assert(controller.showCreateEditUnit == true);
        System.assert(controller.isCreating == false);
        System.assert(controller.isUpdating == true);
        System.assert(controller.newUnit != null);
        //testing the update method
        controller.updateUnit();
        testUnitList = [SELECT Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c 
                        FROM Unit__c 
                        WHERE ID = :testUnit.ID];
        System.assert(testUnit.ID == testUnitList[0].ID);
        //testing the deleting method
        ApexPages.currentPage().getParameters().put('unitID' , controller.allUnits[0].ID);       
        testUnit = controller.allUnits[0];
        controller.deleteUnit();
        testUnitList = [SELECT Name, HP__c, minDMG__c, maxDMG__c, Active__c, Stamina__c 
                        FROM Unit__c 
                        WHERE ID = :testUnit.ID];
        System.assert(testUnitList.isEmpty());
        
        controller.closeCreationEditing();
        System.assert(controller.showCreateEditUnit == false);
        System.assert(controller.newUnit == null);
           
        //testing the fight method
        controller.firstUnit = new Unit__c(Name = 'first', HP__c = 2000, minDMG__c = 10, maxDMG__c = 29, Stamina__c = 1000, Number_Of_Victories__c = 0 , Number_of_Games__c = 0);
        controller.secondUnit = new Unit__c(Name = 'second', HP__c = 200, minDMG__c = 30, maxDMG__c = 49, Stamina__c = 100, Number_Of_Victories__c = 0 , Number_of_Games__c = 0);

        insert controller.firstUnit;
        insert controller.secondUnit;
        controller.fight();
        system.assertEquals(true, controller.winner == controller.firstUnit);
        controller.saveGameResult(controller.winner, controller.looser);
	allUnits = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Number_of_victories__c, 
			    Number_of_Games__c, Position_in_top__c, Percent_of_Victories__c, Stamina__c
			    FROM Unit__c];
        controller.firstUnit = new Unit__c();
        controller.secondUnit = new Unit__c();
        controller.firstChosedUnit = controller.allUnits[0].ID;
        controller.chooseFirstUnit();
        controller.secondChosedUnit = controller.allUnits[1].ID;
        controller.chooseSecondUnit();
        System.assert(controller.firstChosedUnit == controller.allUnits[0].ID);
        System.assert(controller.secondChosedUnit == controller.allUnits[1].ID);
        System.assert(controller.showFirstChosenUnit == true);
        System.assert(controller.showSecondChosenUnit == true);
        //testing the list menu from the page    
        List<SelectOption> options;
        controller.activeUnits = [SELECT Id, Name, HP__c, minDMG__c, maxDMG__c, Active__c, Deactivation_Time__c, Number_of_victories__c, Number_of_Games__c, Position_in_top__c, Percent_of_Victories__c, Stamina__c
                                 FROM Unit__c
                                 WHERE Active__c = true];
        options = controller.getUnitSelectList();
        System.assertEquals(1, options.size());
        
    }
    /**
    * this codeisused for testing  the gameBatch
    */
    @isTest static void gameBatchTest ()
    {
        //creatingdata
        List<Unit__c> unitDataList = new List<Unit__c>();
        Unit__c unit1 = new Unit__c(Name = 'Unit1', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 0);
        Unit__c unit2 = new Unit__c(Name = 'Unit2', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 0);
        Unit__c unit3 = new Unit__c(Name = 'Unit3', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 70);
        Unit__c unit4 = new Unit__c(Name = 'Unit4', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 80);
        Unit__c unit5 = new Unit__c(Name = 'Unit5', HP__c = 100, minDMG__c = 10, maxDMG__c = 20, Active__c = false, Deactivation_Time__c = DateTime.now().addDays(-1), Stamina__c = 95);
        unitDataList.add(unit1);
        unitDataList.add(unit2);
        unitDataList.add(unit3);
        unitDataList.add(unit4);
        unitDataList.add(unit5);

        insert unitDataList;
        //starting our test
        Test.startTest();
        Database.executeBatch(new gameBatch());
        Test.stopTest();
        
        List<Unit__c> unitsList= [SELECT Id, Stamina__c, Active__c
                               FROM Unit__c
                               WHERE Active__c = true];

        System.assertEquals(5, unitsList.size());
        for(Unit__c i: unitsList)
        {
            System.assert(i.Stamina__c >= 10);
			System.assertEquals(true, i.Active__c);
        }
    }
}