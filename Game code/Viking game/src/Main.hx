package;

import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.Lib;
import src.Player;

class Main extends Sprite 
{
	
	var player:Player;
	
	public function new() 
	{
		super();
		
		player = new Player();
		addChild(player);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
		
		
	}

}
