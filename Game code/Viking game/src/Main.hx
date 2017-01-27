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
	var abilityTimerLength:Int = 120;
	var abilityTimer:Int = 0;
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
	var canFireQ:Bool = false;
	
	var velocities:Array<Point>;
	
	var runes:Array<Bitmap> = new Array<Bitmap>();
	
	var runeData:BitmapData = Assets.getBitmapData("img/rune.png");
	
	var UIbarData:BitmapData = Assets.getBitmapData("img/UIbar.png");
	var UIbar:Bitmap;
	
	public function new() 
	{
		super();
		
		//abilityTimer = abilityTimerLength;
		
		keys = [];
		
		textFormat.align = TextFormatAlign.CENTER;
		scoreTextFormat.align = TextFormatAlign.CENTER;
		
		level = new Level();
		addChild(level);
		
		UIbar = new Bitmap(UIbarData);
		UIbar.scaleX = UIbar.scaleY = .5;
		UIbar.y = Lib.current.stage.stageHeight - UIbar.height;
		UIbar.x = Lib.current.stage.stageWidth/2 - UIbar.width/2;
		addChild(UIbar);
		
		addRunes();
		
		addChild(scoreField);
		scoreField.width = 350;
		scoreField.height = 50;
		scoreField.y = 10;
		scoreField.x = 10;
		scoreField.defaultTextFormat = scoreTextFormat;
		scoreField.background = true;
		scoreField.selectable = false;
		scoreField.backgroundColor = 0x058255;
		scoreField.border = true;
		
		addChild(timerField);
		timerField.width = 500;
		timerField.height = 50;
		timerField.y = 10;
		timerField.x = Lib.current.stage.stageWidth - timerField.width - 10;
		timerField.background = true;
		timerField.backgroundColor = 0x058255;
		timerField.defaultTextFormat = scoreTextFormat;
		timerField.selectable = false;
		timerField.border = true;
		
		player = new Player();
		addChild(player);
		
		newGame();
	}
	
	function newGame()
	{		
		spawnTimer = 15;
		spawned = false;
		hit = false;
		enemies = new Array<Enemy>();
		
		//Adding the player
		
		player.tilemap.x = 640;
		player.tilemap.y = 360;
		
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
		enemySpawning();
		
		// Iterating the timer and converting it to seconds
		timer++;
		var timerSeconds = Math.floor(timer / 60);
		
		// Updating the UI every frame
		scoreField.text = ("Your power level is " + score);
		timerField.text = ("You've been alive for " + timerSeconds + " seconds");
		
		// Counting down
		abilityTimer--;
		
		// So the timer doesn't go under 0
		if (abilityTimer < 0)
		{
			abilityTimer = 0;
		}
		/*
		if (hit == false && spawned == true )
		{
			//Check if any enemy collides with the player
			for (enemy in enemies)
			{
				// For the delayed rotation effect
				var enemyRotationSpeed = .5;
				
				// Getting its target(the player)
				var enemyRotationInRadians = Math.atan2( player.tilemap.y + player.tilemap.height/2 - enemy.enemyBitmap.y, player.tilemap.x + player.tilemap.width/2 - enemy.enemyBitmap.x );
				
				// Translating to a sensible unit of measure and applying the rotation with the delay
				var enemyRotationInDegrees = enemyRotationInRadians * 180 / Math.PI;
				if (enemy.enemyBitmap.rotation < enemyRotationInDegrees) enemy.enemyBitmap.rotation += enemyRotationSpeed;
				if (enemy.enemyBitmap.rotation > enemyRotationInDegrees)  enemy.enemyBitmap.rotation -= enemyRotationSpeed;
				
				// Moving it in the direction
				var velocity:Point = Point.polar(2, enemyRotationInRadians);
				enemy.enemyBitmap.x += velocity.x;
				enemy.enemyBitmap.y += velocity.y;
				
				
				// Collision code if any enemy has interacted with the player
				if ((player.tilemap.x + player.tilemap.width/2 > enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 - 50 && player.tilemap.x + player.tilemap.width/2 < enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 + 50)
				&& (player.tilemap.y + player.tilemap.height/2 > enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 - 50 && player.tilemap.y + player.tilemap.height/2 < enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 + 50)) 
				{
					hit = true;
					
					timer = 0;
					score = 0;
					
					// The game over text
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
					
					// No need to track any of this while we're in the restart screen
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, player.onKeyDown); 
					stage.removeEventListener(KeyboardEvent.KEY_UP, player.onKeyUp);
					stage.removeEventListener(Event.ENTER_FRAME, everyFrame);
					
					// Removing all the enemies and abilities
					for (enemy in enemies) removeChild(enemy);
					for (ability in abilities) removeChild(ability);
					
					restartButton  = new Button(restartButtonData);
					restartButton.x = Lib.current.stage.stageWidth/2 - (restartButton.width/2);
					restartButton.y = Lib.current.stage.stageHeight/2 - (restartButton.height/2);
					restartButton.addEventListener(MouseEvent.CLICK, restartClicked);
					addChild(restartButton);
				}
				
			}
		}
		*/
		
		// Code to run for each enemy
		for (enemy in enemies)
		{
			// Code to run for each ability regarding each enemy
			for (ability in abilities)
			{
				// If any ability collides with any enemy
				if ((enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 > ability.x + ability.width/2 - 45 && enemy.enemyBitmap.x + enemy.enemyBitmap.width/2 < ability.x + ability.width/2 + 45)
				&& (enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 > ability.y + ability.height/2 - 45 && enemy.enemyBitmap.y + enemy.enemyBitmap.height/2 < ability.y + ability.height/2 + 45)) 
				{
					// Increase the score, remove the enemy and ability from the screen
					score++;
					enemies.remove(enemy);
					removeChild(enemy);
					abilities.remove(ability);
					removeChild(ability);
				}
			}
		}
		
		// Managing abilities
		// Code to run for every ability in the array(on the screen)
		for (ability in abilities)
		{
			// Making them move
			ability.x += ability.velocity.x;
			ability.y += ability.velocity.y;
			
			// Remove if they're outside of the screen
			if (ability.x > 1300 || ability.y > 750  || ability.x  < 0 || ability.y < 0)
			{
				abilities.remove(ability);
				removeChild(ability);
			}
			
			// Running the animation code in the ability class
			ability.everyFrame();
		}
		
		trace(abilityTimer);
		
		if (keys[81] && abilityTimer == 0) 
		{
			canFireQ = true;
		}
		
		if (runes.length <= 0 && abilityTimer == 0)
		{
			canFireQ = false;
			
			abilityTimer = abilityTimerLength;
		}
		if (abilityTimer == 1) addRunes();
		trace("runes " + runes.length);
		
	}
	
	function addRunes()
	{
		for (i in 0...5)
		{
			var rune:Bitmap = new Bitmap(runeData);
			rune.y = UIbar.y + 10;
			rune.x = 420 + i * 91;
			rune.scaleX = rune.scaleY = .3;
			addChild(rune);
			runes.push(rune);
		}
	}
	
	public function abil(Event: MouseEvent)
	{
		if (canFireQ && runes.length > 0)
		{
			var rune : Bitmap = runes.pop();
			removeChild(rune);
			
			var ability = new Ability();
			
			// Centering its origin point
			ability.tilemap.x = -ability.width / 2;
			ability.tilemap.y = -ability.height / 2;
			
			// Position the ability around the player's hand
			ability.x = player.tilemap.x + 32;
			ability.y = player.tilemap.y + 36;
			
			// Telling it to go towards the mouse
			var rotationInRadians = Math.atan2( Lib.current.stage.mouseY - ability.y, Lib.current.stage.mouseX - ability.x );
			var velocity  = Point.polar(10, rotationInRadians);
			ability.velocity = velocity;
			
			// Making the ability point towards its target
			var rotationInDegrees = rotationInRadians * 180 / Math.PI;
			ability.rotation = rotationInDegrees;
			
			// It's added to the storage array and on the screen
			abilities.push(ability);
			addChild(ability);
		}
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
