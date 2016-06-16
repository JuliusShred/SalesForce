/**
 * This code contains two methods that serve for determining the winner
 * The "Hit" method nrings the damage to the unit that we want to hit
 * The "Fight" method provides the simulation of fighting by calling "Hit" method in the loop
 */
public class Game 
{
    private Unit winner;
    public void Hit(Unit hitter, Unit victim) 
    {   
        Integer damage;
        //there's 20 % possibility that player will fail at hitting his enemy
        if ((Integer)Math.floor(Math.random() * 100) < 20) 
        {
            system.debug(hitter.Name + ' has missed.');
        }
        else 
        {
            // calculating the damage that based on unit's maxDMG and minDMX characteristics
            damage = (Integer)(Math.floor(Math.random() * (hitter.maxDMG - hitter.minDMG + 1) + hitter.minDMG));
            victim.HP -= damage;
            //checking the hp to determine the winner
            if (victim.HP <= 0) 
            {
                winner = hitter;
                return;
            }
            system.debug('Player: ' + victim.Name + ' has been hit, HP = ' + victim.HP);
        }               
    }
    
    public Unit Fight (Unit pl1, Unit pl2) 
    {
        while ((pl1.HP > 0) && (pl2.HP > 0)) 
        {
            Hit(pl2, pl1);
            Hit(pl1, pl2);          	
        }
        return winner;
    }
}