package;

import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.Lib;
import src.Player;
import src.Level;
import src.Enemy;

class Main extends Sprite 
{
	
	var player:Player;
	var enemy:Enemy;
	var level:Level;
	
	public function new() 
	{
		super();
		
		//Adding the player
		player = new Player();
		addChild(player);
		
		//Adding the player
		enemy = new Enemy();
		addChild(enemy);
		
		//Displaying the level
		level = new Level();
		addChild(level);
		
		//This is to check for keypresses in the player class. Can't do it there because Main is special.
		stage.addEventListener(KeyboardEvent.KEY_DOWN, enemy.onKeyDown); 
		stage.addEventListener(KeyboardEvent.KEY_UP, enemy.onKeyUp);
		/*
		stage.addEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown); 
		stage.addEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
		*/
	}

}
