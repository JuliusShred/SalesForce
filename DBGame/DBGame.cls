/**
/**
 * This code contains two methods that serve for determining the winner
 * The "Hit" method nrings the damage to the unit that we want to hit
 * The "Fight" method provides the simulation of fighting by calling "Hit" method in the loop
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

    private Integer Hit(Unit__c hitter, Unit__c victim) 
    {   
        Integer damage = 0;
        String typeOfBlock, typeOfKick;
        /**
     	 * Getting random blosk and hit
     	 */
        typeOfBlock = getBlockKickType((Integer)Math.floor(Math.random() * 4));
        typeOfKick = getBlockKickType((Integer)Math.floor(Math.random() * 4));
        /**
         * there's 20 % possibility that player will fail at hitting his enemy
         */
        if ((Integer)Math.floor(Math.random() * 100) < 20) 
        {
            gameLog.add(hitter.Name + ' has missed.');
        }
        else if (typeOfBlock == typeOfKick)
        {
            gameLog.add(victim.Name + ' used proper block');
        }    
        else 
        {
            /**
         	* calculating the damage that based on unit's maxDMG and minDMX characteristics
         	*/
            damage = (Integer)(Math.floor(Math.random() * (hitter.maxDMG__c - hitter.minDMG__c + 1) + hitter.minDMG__c));
            gameLog.add(victim.Name + ' is blocking his ' + typeOfBlock + ', '
                       + hitter.Name + ' beats in ' +  typeOfKick + '.');    
        }
        gameLog.add(victim.Name + ' gets ' +damage + ' points of damage.');
        return damage;
    }
    
    public Unit__c Fight (Unit__c Unit1, Unit__c Unit2) 
    {
        Unit1_HP = Unit1.HP__c;
        Unit2_HP = Unit2.HP__c;
        while ((Unit1_HP > 0) && (Unit2_HP > 0)) 
        {
            gameLog.add(Unit1.Name + ' HP = ' + Unit1_HP + ', ' + Unit2.Name + ' HP = ' + Unit2_HP + '.');
          	Unit1_HP -= Hit(Unit2, Unit1);
            if (Unit1_HP > 0)
            {
                Unit2_HP -= Hit(Unit1, Unit2);
            }
                      	
        }
        winner = Unit1_HP > Unit2_HP ? Unit1 : Unit2;
        gameLog.add(winner.Name + ' has won ' + '!');
        return winner;
    }
}