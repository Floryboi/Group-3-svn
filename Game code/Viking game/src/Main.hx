package;

import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import openfl.Lib;
import src.Player;
import src.Level;

class Main extends Sprite 
{
	
	var player:Player;
	var level:Level;
	
	public function new() 
	{
		super();
		
		//Adding the player
		player = new Player();
		addChild(player);
		
		//Displaying the level
		level = new Level();
		addChild(level);
		
		//This is to check for keypresses in the player class. Can't do it there because Main is special.
		stage.addEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown); 
		stage.addEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
		stage.addEventListener( MouseEvent.CLICK, player.abil );
		
	}

}
