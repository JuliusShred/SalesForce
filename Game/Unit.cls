/**
 * This code specifies the next player characteristics : Name, HP, his minimum and maximum damage
 */
public class Unit 
{
    public String Name {get; set;}
    public Integer HP {get; set;}
    public Integer minDMG {get; set;}
    public Integer maxDMG {get; set;}
    public Unit(String Name, Integer HP, Integer minDMG, Integer maxDMG) 
    {
        this.Name = Name;
        this.HP = HP;
        this.minDMG = minDMG;
        this.maxDMG = maxDMG;
    }
}