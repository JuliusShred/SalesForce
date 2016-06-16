public class GameController 
{
    public Unit pl1 {get; set;}
    public Unit pl2 {get; set;}
    public Unit winner {get; set;}
    public Game game {get; set;}

    public GameController () 
    {
        pl1 = new Unit();
        pl2 = new Unit();
    }
    
    public void fight() 
    {
        game = new Game();
        winner = new Unit();
        winner = game.fight(pl1, pl2);
    }
}