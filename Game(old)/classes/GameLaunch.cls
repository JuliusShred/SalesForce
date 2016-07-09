Unit bigDaddy = new Unit('bigDaddy', 200, 20, 40);
Unit seriousSam = new Unit('seriousSam', 200, 10, 40);
Game game = new Game();
Unit winner = new Unit();
winner = game.Fight(bigDaddy, seriousSam);
system.debug(winner.Name + ' has won ' + 'with ' + winner.HP+' HP.');