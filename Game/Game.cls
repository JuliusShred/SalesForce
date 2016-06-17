/**
 * This code contains two methods that serve for determining the winner
 * The "Hit" method nrings the damage to the unit that we want to hit
 * The "Fight" method provides the simulation of fighting by calling "Hit" method in the loop
 */
public class Game 
{
    private Unit winner;
    
    /**
     * This method returns the type of hit/bock. The type depends of randomly ganerated number
     */
    private String getBlockKickType(Integer typeOfBlock) {
        
		String BlockKick;    
        
        if (typeOfBlock == 0)
        {
            BlockKick = 'Head';
        } 
        else if (typeOfBlock == 1)
        {
            BlockKick = 'Chest';
        }
        else if (typeOfBlock == 2)
        {
            BlockKick = 'Belly';
        }
        else if (typeOfBlock == 3)
        {
            BlockKick = 'Groin';
        }
        return BlockKick;
    }

    private void Hit(Unit hitter, Unit victim) 
    {   
        Integer damage, typeOfBlock, typeOfKick;
        
        /**
     	 * Getting random blosk and hit
     	 */
        typeOfBlock = (Integer)Math.floor(Math.random() * 4);
        typeOfKick = (Integer)Math.floor(Math.random() * 4);
		
        /**
         * there's 20 % possibility that player will fail at hitting his enemy
         */
        if ((Integer)Math.floor(Math.random() * 100) < 20) 
        {
            system.debug(hitter.Name + ' has missed.');
        }
        else if (typeOfBlock == typeOfKick)
        {
            system.debug(victim.Name + ' used proper block');
        }    
        else 
        {
            /**
         	* calculating the damage that based on unit's maxDMG and minDMX characteristics
         	*/
            damage = (Integer)(Math.floor(Math.random() * (hitter.maxDMG - hitter.minDMG + 1) + hitter.minDMG));
            victim.HP -= damage;
            /**
         	* checking the hp to determine the winner
         	*/
            if (victim.HP <= 0) 
            {
                winner = hitter;
                return;
            }
            system.debug(victim.Name + ' is blocking his ' + getBlockKickType(typeOfBlock));
            system.debug(hitter.Name + ' beats in ' +  getBlockKickType(typeOfKick));
            system.debug(victim.Name + ' gets ' + damage + ' points of damage');
        }  
    }
    
    public Unit Fight (Unit pl1, Unit pl2) 
    {
        while ((pl1.HP > 0) && (pl2.HP > 0)) 
        {
            system.debug(pl1.Name + ' HP = ' + pl1.HP + ', ' + pl2.Name + ' HP = ' + pl2.HP);
            system.debug('~~~~~~~~~~~~~~');
          	Hit(pl2, pl1);
            Hit(pl1, pl2);          	
        }
        return winner;
    }
}