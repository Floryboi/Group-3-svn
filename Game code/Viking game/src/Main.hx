package;

import flash.events.Event;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import openfl.Lib;
import src.Player;
import src.Level;
import src.Enemy;

import openfl.geom.Point;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;


class Main extends Sprite 
{
	
	var player:Player;
	//var enemy:Enemy;
	var level:Level;
	
	var textFormat:TextFormat = new TextFormat("Tahoma", 72, 4967498, true);
	var endGameField = new TextField();
	
	var hit:Bool = false;
	var spawned:Bool = false;
	
	var spawnTimer:Int = 60;
	var enemies:Array<Enemy> = new Array<Enemy>();
	
	public function new() 
	{
		super();
		
		textFormat.align = TextFormatAlign.CENTER;
		
		//Adding the player
		player = new Player();
		addChild(player);
		
		//Adding the player
		var enemy = new Enemy();
		addChild(enemy);
		
		//Displaying the level
		level = new Level();
		addChild(level);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown); 
		stage.addEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
		
		stage.addEventListener(Event.ENTER_FRAME, everyFrame);
	}
	
	function everyFrame(evt:Event):Void
	{
		enemySpawning();
		
		if (hit == false && spawned == true)
		{
			for (enemy in enemies)
			{
			var rotationInRadians = Math.atan2( player.playerBitmap.y + player.playerBitmap.height/2 - enemy.enemyBitmap.y, player.playerBitmap.x + player.playerBitmap.width/2 - enemy.enemyBitmap.x );
			
			// make sure this arrow points in the same direction (towards the mouse)
			enemy.enemyBitmap.rotation = rotationInRadians * 180 / Math.PI;
			
			// move in the direction this sprite is rotated
			var velocity:Point = Point.polar(3, rotationInRadians);
			enemy.enemyBitmap.x += velocity.x;
			enemy.enemyBitmap.y += velocity.y;
			}
		}
		
		if (hit == false && spawned == true )
		{
			for (enemy in enemies)
			{
			if ((player.playerBitmap.x + player.playerBitmap.width/2 > enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 - 50 && player.playerBitmap.x + player.playerBitmap.width/2 < enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 + 50)
			&& (player.playerBitmap.y + player.playerBitmap.height/2 > enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 - 50 && player.playerBitmap.y + player.playerBitmap.height/2 < enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 + 50)) 
			{
				hit = true;
				
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
			}
			}
		}
	}
	
	function enemySpawning()
	{
		spawnTimer -= 1;
		trace(spawnTimer);
		if (spawnTimer == 0)
		{
			spawned = true;
			var enemyWave:Int = 4;
			for (i in 0 ... enemyWave)
			{
				var spawningLocationsx:Array<Float> = [0, 1248, 0, 1248];
				var spawningLocationsy:Array<Float> = [0, 0, 688, 688];
				
				for (v in 0...4)
				{
					var enemy:Enemy = new Enemy();
					enemy.enemyBitmap.x = spawningLocationsx[v];
					enemy.enemyBitmap.y = spawningLocationsy[v];
					enemies.push(enemy);
					addChild(enemy);
					trace("donger");
				}
				spawnTimer = 60;
			}
		}
	}
}
