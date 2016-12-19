package;

import openfl.events.KeyboardEvent;
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
		
		player = new Player();
		addChild(player);
		level = new Level();
		addChild(level);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
		
		
	}

}
