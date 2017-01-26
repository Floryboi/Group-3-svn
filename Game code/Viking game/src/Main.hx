package;

import flash.events.Event;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.Lib;
import src.Player;
import src.Level;
import src.Enemy;
import src.Ability;


import openfl.geom.Point;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class Main extends Sprite 
{
	
	var player:Player;
	var level:Level;
	
	var restartButtonData:BitmapData = Assets.getBitmapData( "img/restart.png" );
	var restartButton:Button;
	var textFormat:TextFormat = new TextFormat("Tahoma", 72, 4967498, true);
	var scoreTextFormat:TextFormat = new TextFormat("Verdana", 36, 495614, true);
	var endGameField = new TextField();
	
	var hit:Bool = false;
	var spawned:Bool = false;
	
	var spawnTimer:Int = 60;
	var abilityTimer:Int = 30;
	var timer:Int = 0;
	
	var enemies:Array<Enemy>;
	
	var ability : Ability; 
	public var abilitied : Bool = false;  //A check for making abilities work
	public var clicked : Bool = true;     //A-nother check for making abilities work
	public var rotationInRadians = Math.atan2( 0, 0 );
	var abilities : Array<Ability> = [];
	public var keys:Array<Bool>; //Array in which we store the keyboard keys and their values for pressed or not.
	var score:Int = 0;
	var scoreField:TextField = new TextField();
	var timerField:TextField = new TextField();
	var canFireQ:Bool = true;
	
	var velocities:Array<Point>;
	
	public function new() 
	{
		super();
		
		keys = [];
		
		textFormat.align = TextFormatAlign.CENTER;
		scoreTextFormat.align = TextFormatAlign.CENTER;
		
		level = new Level();
		addChild(level);
		
		addChild(scoreField);
		scoreField.width = 350;
		scoreField.height = 50;
		scoreField.y = 10;
		scoreField.x = Lib.current.stage.stageWidth/2 - scoreField.width/2;
		scoreField.defaultTextFormat = scoreTextFormat;
		scoreField.background = true;
		scoreField.selectable = false;
		scoreField.backgroundColor = 0x058255;
		scoreField.border = true;
		
		addChild(timerField);
		timerField.width = 400;
		timerField.height = 50;
		timerField.y = Lib.current.stage.stageHeight - timerField.height - 10;
		timerField.x = Lib.current.stage.stageWidth/2 - timerField.width/2;
		timerField.defaultTextFormat = scoreTextFormat;
		timerField.selectable = false;
		timerField.border = true;
		
		player = new Player();
		addChild(player);
		
		newGame();
	}
	
	function newGame()
	{		
		spawnTimer = 60;
		spawned = false;
		hit = false;
		enemies = new Array<Enemy>();
		
		//Adding the player
		
		player.playerBitmap.x = 640;
		player.playerBitmap.y = 360;
		
		//Adding an enemy
		var enemy = new Enemy();
		addChild(enemy);
		enemy.x = enemy.y = -2000;		
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown); 
		stage.addEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
		
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown); 
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		
		stage.addEventListener(MouseEvent.CLICK, abil);
		
		stage.addEventListener(Event.ENTER_FRAME, everyFrame);
	}
	
	function everyFrame(evt:Event):Void
	{
		//enemySpawning();
		
		timer++;
		var timerSeconds = Math.floor(timer / 60);
		
		scoreField.text = ("Your power level is " + score);
		timerField.text = ("You've been alive for " + timerSeconds);
		
		abilityTimer--;
		
		if (abilityTimer < 0)
		{
			abilityTimer = 0;
		}
		
		
		if (hit == false && spawned == true)
		{
			for (enemy in enemies)
			{
				var enemyRotationSpeed = .5;
				var enemyRotationInRadians = Math.atan2( player.playerBitmap.y + player.playerBitmap.height/2 - enemy.enemyBitmap.y, player.playerBitmap.x + player.playerBitmap.width/2 - enemy.enemyBitmap.x );
				
				// make sure this arrow points in the same direction (towards the mouse)
				var enemyRotationInDegrees = enemyRotationInRadians * 180 / Math.PI;
				
				if (enemy.enemyBitmap.rotation < enemyRotationInDegrees) enemy.enemyBitmap.rotation += enemyRotationSpeed;
				if (enemy.enemyBitmap.rotation > enemyRotationInDegrees)  enemy.enemyBitmap.rotation -= enemyRotationSpeed;
				
				// move in the direction this sprite is rotated
				var velocity:Point = Point.polar(2, enemyRotationInRadians);
				enemy.enemyBitmap.x += velocity.x;
				enemy.enemyBitmap.y += velocity.y;
			}
		}
		/*
		if (hit == false && spawned == true )
		{
			//Check if any enemy collides with the player
			for (enemy in enemies)
			{
				if ((player.playerBitmap.x + player.playerBitmap.width/2 > enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 - 50 && player.playerBitmap.x + player.playerBitmap.width/2 < enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 + 50)
				&& (player.playerBitmap.y + player.playerBitmap.height/2 > enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 - 50 && player.playerBitmap.y + player.playerBitmap.height/2 < enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 + 50)) 
				{
					hit = true;
					
					addChild(endGameField);
					endGameField.width = 500;
					endGameField.height = 85;
					endGameField.y = Lib.current.stage.stageHeight / 2 - endGameField.height * 2;
					endGameField.x = Lib.current.stage.stageWidth/2 - endGameField.width/2;
					endGameField.defaultTextFormat = textFormat;
					endGameField.background = true;
					endGameField.backgroundColor = 0x493815;
					endGameField.border = true;
					endGameField.text = ("Off to Valhalla");
					
					//This fixes the player floating off in nothingness
					player.keys = [];
					
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown); 
					stage.removeEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
					stage.removeEventListener(Event.ENTER_FRAME, everyFrame);
					
					//Removing all the enemies
					for (enemy in enemies) removeChild(enemy);
					
					restartButton  = new Button(restartButtonData);
					restartButton.x = Lib.current.stage.stageWidth/2 - (restartButton.width/2);
					restartButton.y = Lib.current.stage.stageHeight/2 - (restartButton.height/2);
					restartButton.addEventListener(MouseEvent.CLICK, restartClicked);
					addChild(restartButton);
				}
			}
		}*/
		for (enemy in enemies)
		{
			for (ability in abilities)
			{
				if ((enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 > ability.x + ability.width/2 - 30 && enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 < ability.x + ability.width/2 + 30)
				&& (enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 > ability.y + ability.height/2 - 30 && enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 < ability.y + ability.height/2 + 30)) 
				{
					score++;
					enemies.remove(enemy);
					removeChild(enemy);
					abilities.remove(ability);
					removeChild(ability);
				}
			}
		}
		
		//Managing abilities
		
		for (ability in abilities)
		{
			ability.x += ability.velocity.x;
			ability.y += ability.velocity.y;
			
			if (ability.x > 1300 || ability.y > 750  || ability.x  < 0 || ability.y < 0)
			{
				removeChild(ability);
			}
		}
	}
	
	public function abil(Event: MouseEvent)
	{
		var ability = new Ability();
		
		ability.x = player.playerBitmap.x;
		ability.y = player.playerBitmap.y;
		
		var rotationInRadians = Math.atan2( Lib.current.stage.mouseY - ability.y, Lib.current.stage.mouseX - ability.x );
		var velocity  = Point.polar(2, rotationInRadians);
		ability.velocity = velocity;
		// make sure this arrow points in the same direction (towards the mouse)
		var rotationInDegrees = rotationInRadians * 180 / Math.PI;
		
		// move in the direction this sprite is rotated
		
		ability.x = player.playerBitmap.x + 32;
		ability.y = player.playerBitmap.y + 36;
		
		abilities.push(ability);
		addChild(ability);
		
		trace("click");
	}
	
	function enemySpawning()
	{
		//So they don't spawn infinitely. To be replaced with a wave counter
		if (enemies.length < 10)
		{
			//Count down each frame until we get to the spawn point
			spawnTimer -= 1;
			
			if (spawnTimer == 0)
			{
				spawned = true;
				
				//How many times will we spawn this wave
				var enemyWave:Int = 4;
				
				for (i in 0 ... enemyWave)
				{
					//Generating random coordinates
					var randX:Int = Math.floor(Math.random() * 1300);
					var randY:Int = Math.floor(Math.random() * 750);
					
					//If the coordinate is on the screen
					if (randX < 1300 && randX > -10 && randY < 750 && randY > -10)
					{
						//We randomly decide whether we overwrite the X or the Y to be outside the screen.
						//This way it's still random, but only one coordinate at a time, so we can be sure it's outside the screen.
						var randSmooth : Int = Math.floor(Math.random() * 4);
						
						if (randSmooth == 1) randY = -30;
						if (randSmooth == 0) randX = -30;
						if (randSmooth == 2) randX = 1300;
						if (randSmooth == 3) randY = 730;
					}
					
					//Spawn enemy, possition add, reset timer
					var enemy:Enemy = new Enemy();
					enemy.enemyBitmap.x = randX;
					enemy.enemyBitmap.y = randY;
					enemies.push(enemy);
					addChild(enemy);
					
					spawnTimer = 60;
				}
			}
		}
	}
	
	private function restartClicked(evt:Event):Void
	{
		removeChild(restartButton);
		removeChild(endGameField);
		newGame();
	}
		
	public function onKeyDown(evt:KeyboardEvent):Void
	{
		
		keys[evt.keyCode] = true;
	}
	
	public function onKeyUp(evt:KeyboardEvent):Void
	{
		keys[evt.keyCode] = false;
	}
}
