/**
 * This code contains methods that serve for determining the winner
 */
public class Game 
{
    private Unit__c winner;
    public List<String> gameLog {get; set;}
    private Decimal Unit1_HP;
    private Decimal Unit2_HP;
    
    public Game() 
    {
        winner = new Unit__c();
        gameLog = new List<String>();      
    }
    /**
     * This method returns the type of hit/bock. The type depends of randomly ganerated number
     */
    private String getBlockKickType(Integer partOfBody) {
        
        String BlockKick; 
        if (partOfBody == 0)
        {
            BlockKick = 'Head';
        } 
        else if (partOfBody == 1)
        {
            BlockKick = 'Chest';
        }
        else if (partOfBody == 2)
        {
            BlockKick = 'Belly';
        }
        else if (partOfBody == 3)
        {
            BlockKick = 'Groin';
        }
        return BlockKick;
    }
    /**
    * This method will server for decreasing the unit's stamina during the fight
    * it depends on the strength of the hit
    */
    public Decimal spentStaminaPoints (Integer damage)
    {
        return damage/10;
    }
    /**
    * This method returns the damage to harm the unit
    */
    private Integer Hit(Unit__c hitter, Unit__c victim) 
    {   
        Integer damage = 0;
        Decimal spentStaminaPoints;
        String typeOfBlock, typeOfKick;
        /**
         * Getting random blosk and hit
         */
        typeOfBlock = getBlockKickType((Integer)Math.floor(Math.random() * 4));
        typeOfKick = getBlockKickType((Integer)Math.floor(Math.random() * 4));
        /**
        * calculating the damage that based on unit's maxDMG and minDMX characteristics
        * assigning the to the spentStaminaPointsm which unit will lost in any case
        */
        spentStaminaPoints = spentStaminaPoints(damage = (Integer)(Math.floor(Math.random() * (hitter.maxDMG__c - hitter.minDMG__c + 1) + hitter.minDMG__c)));
        /**
         * there's 20 % possibility that player will fail at hitting his enemy
         */
        if ((Integer)Math.floor(Math.random() * 100) < 20) 
        {
            damage = 0;
            gameLog.add(hitter.Name + ' has missed.');
        }
        else if (typeOfBlock == typeOfKick)
        {
            damage = 0;
            gameLog.add(victim.Name + ' used proper block.');
        }    
        else 
        {
            
            
            gameLog.add(victim.Name + ' is blocking his ' + typeOfBlock + ', '
                       + hitter.Name + ' beats in ' +  typeOfKick + '.');    
        }
        gameLog.add(victim.Name + ' gets ' +damage + ' points of damage, ' + hitter.Name + ' lost ' +spentStaminaPoints + ' points of stamina.');
        //Hitting unit wastes his stamina even if he didn't harm his opponent (missed or opponent used the right block)
        hitter.Stamina__c -= spentStaminaPoints;
        return damage;
    }
    
    /**
    * This method determins which unit will hit next
    */
    public Unit__c whoIsHitting (Unit__c Unit1, Unit__c Unit2)
    {
        if ((Integer)Math.floor(Math.random() * 100) < 50)
        {
            return Unit1;
        } else
        {
            return Unit2;
        }
    }
    /**
    * The main method which determins the winner
    */
    public Unit__c Fight (Unit__c Unit1, Unit__c Unit2) 
    {
        if (Unit1 != null && Unit2 !=null)
        {
            Unit1_HP = Unit1.HP__c;
            Unit2_HP = Unit2.HP__c;
            while (true) 
            {
                gameLog.add(Unit1.Name + ' HP = ' + Unit1_HP + ', ' + Unit2.Name + ' HP = ' + Unit2_HP + '.');
                if (whoIsHitting(Unit1, Unit2) == Unit1)
                {
                    Unit2_HP -= Hit(Unit1, Unit2);
                    if (Unit2.Stamina__c <= 0)
                    {
                        gameLog.add(Unit2.Name + ' has no more strength left.');
                        Unit2.Stamina__c = 0;
                        Unit2_HP = 0;
                        break;
                    }
                    if (Unit2_HP <= 0) break;
                }
                else
                {
                    Unit1_HP -= Hit(Unit2, Unit1);
                    if (Unit1.Stamina__c <= 0)
                    {
                        gameLog.add(Unit1.Name + ' has no more strength left.');
                        Unit1.Stamina__c = 0;
                        Unit1_HP = 0;
                        break;
                    }
                    if (Unit1_HP <= 0) break;
                }
            }
            winner = Unit1_HP > Unit2_HP ? Unit1 : Unit2;
            gameLog.add(winner.Name + ' has won!');
            return winner;
        } else
        {
            throw new GameException('Unit cannot be null');
        }
        
    }
}