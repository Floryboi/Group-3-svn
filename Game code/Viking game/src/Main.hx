package;

import flash.events.Event;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.Lib;
import src.Player;
import src.Level;
import src.Enemy;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;


class Main extends Sprite 
{
	
	var player:Player;
	var enemy:Enemy;
	var level:Level;
	
	var textFormat:TextFormat = new TextFormat("Tahoma", 72, 4967498, true);
	var endGameField = new TextField();
	
	public function new() 
	{
		super();
		
		textFormat.align = TextFormatAlign.CENTER;
		
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
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown); 
		stage.addEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
		
		stage.addEventListener(Event.ENTER_FRAME, everyFrame);
	}
	
	function everyFrame(evt:Event):Void
	{
		if ((player.playerBitmap.x + player.playerBitmap.width/2 > enemy.enemyBitmap.x - 20 && player.playerBitmap.x + player.playerBitmap.width/2 < enemy.enemyBitmap.x + 20)
		&& (player.playerBitmap.y + player.playerBitmap.height/2 > enemy.enemyBitmap.y - 20 && player.playerBitmap.y + player.playerBitmap.height/2 < enemy.enemyBitmap.y + 20)) 
		{
			trace("Hit");
			
			addChild(endGameField);
			endGameField.width = 500;
			endGameField.height = 85;
			endGameField.y = Lib.current.stage.stageHeight/2 - endGameField.height/2;
			endGameField.x = Lib.current.stage.stageWidth/2 - endGameField.width/2;
			endGameField.defaultTextFormat = textFormat;
			endGameField.background = true;
			endGameField.backgroundColor = 0x493815;
			endGameField.border = true;
			endGameField.text = ("RIP in Peace");
			
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown); 
			stage.removeEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
			
			//player.playerBitmap.x = player.playerBitmap.y = 200;
		}
	}

}
