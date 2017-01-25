package src;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.events.Event;
//import openfl.events.KeyboardEvent;
//import openfl.geom.Point;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
//import src.Level;
//import openfl.Lib;

class Enemy extends Sprite
{
	
	//private var gravity:Float = 1.5;
	//private var jumpHeight:Float = 15.0;
	//private var velocity:Point = new Point(0, 0); // Variable where we store the velocity to be added to the player. This is applied at the end of every frame loop.
	//private var keys:Array<Bool>; //Array in which we store the keyboard keys and their values for pressed or not.
	//private var isOnGround:Bool; //Are we colliding?
	//private var jumped:Bool = false; //To keep track if we're in the air from a jump
	public var enemyBitmap:Bitmap;
	//var canSpacebar:Bool = true; //Can we press spacebar again? So we don't do the infinte hop
	//var level : Level; //Referencing the level class, so we can read from it
	//var direction : Bool = true;
	
	//run once upon creation
	public function new()
	{
		super();
		
		//level = new Level(); //Reference to the level
		
		//Assigning the player's texture
		var enemyData:BitmapData = Assets.getBitmapData( "img/SpikeDude.png" ); 
    	enemyBitmap = new Bitmap( enemyData );
		
		//We don't have to do this, but he looks much better. Draws the focus to him instead of the ground or background
		enemyBitmap.scaleX = 2;
		enemyBitmap.scaleY = 2;
		enemyBitmap.x = -enemyBitmap.width / 2;
		enemyBitmap.y = -enemyBitmap.height / 2;
		
		enemyBitmap.x = enemyBitmap.y = 300;
		
		addChild(enemyBitmap); //Adding the player sprite to the scene
		
		//keys = []; //Defining the array we use to store the keyboard keys. It's empty because it's populated by the respective functions
		
		//this.addEventListener(Event.ENTER_FRAME, everyFrame); //The game is frame based, so we're tracking things that happen every frame in the everyFrame function
	}
	/*
	//Code that is run every frame
	function everyFrame(evt:Event):Void
	{
		//velocity.y += gravity; //Applying the acceleration of gravity to the player. This happens constantly and is only nullified by the collision functions
		/*
		//Movement
		if (keys[39]) //Moving Right
		{
			//enemyBitmap.scaleX =  2;
			velocity.x = 7; //Movement speed
		}
		else if (keys[37]) //Moving Left
		{
			//enemyBitmap.scaleX = -2; //Bad implementation someone please fix it
			velocity.x = -7; //Movement speed
		}
		else //Not Moving
		{
			velocity.x = 0;
		}
		
		//Jumping
		if (keys[32] && isOnGround && !jumped ) //If the spacebar is pressed and we're on the ground and we have not already jumped
		{
			velocity.y = -jumpHeight; //Negative velocity is applied to the player, so they move up
			jumped = true; //Keeping track we've jumped
			
		}
		
		//Making so that player has to relese SPACE to jump again
		if (!keys[32] && jumped)
		{
			jumped = false;
		}
		
		
		if (enemyBitmap.y >= stage.height + 80) enemyBitmap.y = stage.height + 80;
		if (enemyBitmap.y <= 10) enemyBitmap.y = 10;
		if (enemyBitmap.x <= 10) enemyBitmap.x = 10;
		if (enemyBitmap.x >= stage.width - 60) enemyBitmap.x = stage.width - 60;
		
		//var tileCoords:Point = new Point(0, 0); //Where the tile we're moving into is located based on the grid
		//var approximateCoords:Point = new Point(); //Where the player is located based on the level grid
		
		//Applying the velocities to the player
		//enemyBitmap.y += velocity.y;	//Apply the y velocity to the player
		//checkBottomCollision(tileCoords, approximateCoords);	//Apply bottom collision
		
		//enemyBitmap.x += velocity.x;	//Apply the x velocity to the player
		//checkRightCollision(tileCoords, approximateCoords);
		//checkLeftCollision(tileCoords, approximateCoords);
		
		//artificialIntelligence(direction);
		
		//if (velocity.y != 0) isOnGround = false; //Infinite jumping without this, since we removed the ground check in the beginning
	}*/
	/*
	public function artificialIntelligence(direction:Bool)
	{//This function moves the enemy based on the input of the collision functions
		if (direction)	//true = right
		{
			velocity.x = 7;
		}
		else if (!direction)	//false = left
		{
			velocity.x = -7;
		}
	}*/
	/*
	function checkTopCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Bottom collision
		
		if (velocity.y <= 0) 
		{//If we're falling
			
			//Turning the player's actual coordinates to ones based on our grid
				//First half of this equasion sets the collision point as the bottom of our character.
				//We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	
			approximateCoords.y = (enemyBitmap.y) / level.gridSize; 
			approximateCoords.x = (enemyBitmap.x ) / level.gridSize; 
			
			tileCoords.y = Math.floor(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				enemyBitmap.y = (tileCoords.y) * level.gridSize + enemyBitmap.height/2; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.y = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				enemyBitmap.y = (tileCoords.y ) * level.gridSize + enemyBitmap.height/2;
				velocity.y = 0;
				isOnGround = true;
			} 
		} 
	}
	
	function checkBottomCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Bottom collision
		
		if (velocity.y >= 0) 
		{//If we're falling
			
			//Turning the player's actual coordinates to ones based on our grid
				//First half of this equasion sets the collision point as the bottom of our character.
				//We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	
			approximateCoords.y = (enemyBitmap.y + enemyBitmap.height / 2) / level.gridSize; 
			approximateCoords.x = (enemyBitmap.x + enemyBitmap.width / 2 ) / level.gridSize; 
			
			tileCoords.y = Math.ceil(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				enemyBitmap.y = (tileCoords.y) * level.gridSize - enemyBitmap.height; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.y = 0; //Reset the player's velocity
				isOnGround = true;		
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				enemyBitmap.y = (tileCoords.y ) * level.gridSize - enemyBitmap.height;
				velocity.y = 0;
				isOnGround = true;
			} 
		} 
	}
	
	function checkRightCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Bottom collision
		
		if (velocity.x > 0) 
		{//If we're falling
			
			//Turning the player's actual coordinates to ones based on our grid
				//First half of this equasion sets the collision point as the bottom of our character.
				//We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	
			approximateCoords.y = (enemyBitmap.y ) / level.gridSize; 
			approximateCoords.x = (enemyBitmap.x + enemyBitmap.width - 5) / level.gridSize; 
			
			tileCoords.y = Math.ceil(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				enemyBitmap.x = (tileCoords.x) * level.gridSize - enemyBitmap.width; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.x = 0; //Reset the player's velocity
				isOnGround = true;
				direction = false;
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.y = Math.floor(approximateCoords.y);
			
			if (isBlock(tileCoords)) {
				enemyBitmap.x = (tileCoords.x) * level.gridSize - enemyBitmap.width ;
				velocity.x = 0;
				isOnGround = true;
				direction = false;
			} 
		} 
		
	}
	
	function checkLeftCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Left collision
		
		if (velocity.x <= 0) 
		{//If we're moving left
			
			//Turning the player's actual coordinates to ones based on our grid
			//	First half of this equasion sets the collision point as the bottom of our character.
				//We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	
				
			approximateCoords.y = (enemyBitmap.y) / level.gridSize; 
			approximateCoords.x = (enemyBitmap.x) / level.gridSize; 
			
			tileCoords.y = Math.floor(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				enemyBitmap.x = (tileCoords.x) * level.gridSize + enemyBitmap.width; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.x = 0; //Reset the player's velocity
				isOnGround = true;	
				direction = true;
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.y = Math.ceil(approximateCoords.y);
			
			if (isBlock(tileCoords)) {
				enemyBitmap.x = (tileCoords.x) * level.gridSize + enemyBitmap.width ;
				velocity.x = 0;
				isOnGround = true;
				direction = true;
			} 
		} 
		
	}
	
	function isBlock(coords:Point):Bool 
	{//Checking if the coordinate we're moving towards is a block
		return level.map[Math.round(coords.y)][Math.round(coords.x)] == 1;
	}
	
	public function onKeyDown(evt:KeyboardEvent):Void
	{
		
		keys[evt.keyCode] = true;
		if (canSpacebar)
		{
			if (evt.keyCode == 32)
			{
				trace("Char code: " + evt.charCode);
				trace("Key code: " + evt.keyCode);
				//trace("Pressed space");
				canSpacebar = false;
			}
		}
	}
	
	public function onKeyUp(evt:KeyboardEvent):Void
	{
		keys[evt.keyCode] = false;
		canSpacebar = true;
		
	}
	*/
}