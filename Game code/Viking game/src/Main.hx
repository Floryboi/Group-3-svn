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
		player.playerBitmap.x = 640;
		player.playerBitmap.y = 360;
		
		//Adding an enemy
		var enemy = new Enemy();
		addChild(enemy);
		enemy.x = enemy.y = -2000;
		
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
		/*
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
		}*/
	}
	
	function enemySpawning()
	{
		if (enemies.length < 10)
		{
			spawnTimer -= 1;
			//trace(spawnTimer);
			
			if (spawnTimer == 0)
			{
				spawned = true;
				
				var enemyWave:Int = 4;
				
				for (i in 0 ... enemyWave)
				{
					var spawningLocationsx:Array<Float> = [0, 1300, 0, 1300];
					var spawningLocationsy:Array<Float> = [0, 0, 750, 750];
					
					var randx:Int = Math.floor(Math.random() * 1300);
					var randy:Int = Math.floor(Math.random() * 750);
					
					if (randx < 1300 && randx > -10 && randy < 750 && randy > -10)
					{
						var randSmooth : Int = Math.floor(Math.random() * 4);
						if (randSmooth == 1) randy = -30;
						if (randSmooth == 0) randx = -30;
						if (randSmooth == 2) randx = 1300;
						if (randSmooth == 3) randy = 730;
					}
					
					var enemy:Enemy = new Enemy();
					enemy.enemyBitmap.x = randx;
					enemy.enemyBitmap.y = randy;
					enemies.push(enemy);
					addChild(enemy);
					
					spawnTimer = 60;
				}
			}
		}
	}
}