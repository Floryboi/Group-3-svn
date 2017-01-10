package src;

import openfl.Assets;
import openfl.display.Sprite;
import flash.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import src.Level;

class Player extends Sprite
{
	var slowdown: Float = .5;
	var speed : Float = 2;
	private var jumpHeight:Float = 15.0;
	private var velocity:Point = new Point(0, 0); // Variable where we store the velocity to be added to the player. This is applied at the end of every frame loop.
	private var keys:Array<Bool>; //Array in which we store the keyboard keys and their values for pressed or not.
	private var isOnGround:Bool; //Are we colliding?
	private var jumped:Bool = false; //To keep track if we're in the air from a jump
	private var playerBitmap:Bitmap;
	var canSpacebar:Bool = true; //Can we press spacebar again? So we don't do the infinte hop
	var level : Level; //Referencing the level class, so we can read from it
	
	//run once upon creation
	public function new()
	{
		super();
		
		level = new Level(); //Reference to the level
		
		//Assigning the player's texture
		var playerData:BitmapData = Assets.getBitmapData( "img/VikingGood.png" ); 
    	playerBitmap = new Bitmap( playerData );
		
		//We don't have to do this, but he looks much better. Draws the focus to him instead of the ground or background
		playerBitmap.scaleX = 2;
		playerBitmap.scaleY = 2;
		
		addChild(playerBitmap); //Adding the player sprite to the scene
		
		keys = []; //Defining the array we use to store the keyboard keys. It's empty because it's populated by the respective functions
		
		this.addEventListener(Event.ENTER_FRAME, everyFrame); //The game is frame based, so we're tracking things that happen every frame in the everyFrame function
	}
	
	//Code that is run every frame
	function everyFrame(evt:Event):Void
	{		
		//Movement
		if (keys[39]) //Moving Right
		{
			//playerBitmap.scaleX =  2;
			if (velocity.x < 7) velocity.x += speed; //Movement speed
		}
		if (keys[37]) //Moving Left
		{
			//playerBitmap.scaleX = -2; //Bad implementation someone please fix it
			if (velocity.x > -7) velocity.x -= speed; //Movement speed
		}
		if (keys[40]) //Moving Down
		{
			//playerBitmap.scaleX = -2; //Bad implementation someone please fix it
			if (velocity.y < 7) velocity.y += speed; //Movement speed
		}
		if (keys[38]) //Moving Up
		{
			//playerBitmap.scaleX = -2; //Bad implementation someone please fix it
			if (velocity.y > -7) velocity.y -= speed; //Movement speed
		}
		
		else //Not Moving
		{
			if (velocity.x > 0) velocity.x -= slowdown;
			if (velocity.x < 0) velocity.x += slowdown;
			if (velocity.y > 0) velocity.y -= slowdown; 
			if (velocity.y < 0) velocity.y += slowdown;
		}
		
		var tileCoords:Point = new Point(0, 0); //Where the tile we're moving into is located based on the grid
		var approximateCoords:Point = new Point(); //Where the player is located based on the level grid
		
		//Applying the velocities to the player
		playerBitmap.y += velocity.y;	//Apply the y velocity to the player
		checkBottomCollision(tileCoords, approximateCoords);	//Apply bottom collision
		checkTopCollision(tileCoords, approximateCoords);
		
		playerBitmap.x += velocity.x;	//Apply the x velocity to the player
		checkRightCollision(tileCoords, approximateCoords);
		checkLeftCollision(tileCoords, approximateCoords);
		
		if (velocity.y != 0) isOnGround = false; //Infinite jumping without this, since we removed the ground check in the beginning
	}
	
	function checkBottomCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Bottom collision
		
		if (velocity.y >= 0) 
		{//If we're falling
			
			/*Turning the player's actual coordinates to ones based on our grid
				First half of this equasion sets the collision point as the bottom of our character.
				We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	*/
			approximateCoords.y = (playerBitmap.y + playerBitmap.height / 2 ) / level.gridSize; 
			approximateCoords.x = (playerBitmap.x ) / level.gridSize; 
			
			tileCoords.y = Math.ceil(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				playerBitmap.y = (tileCoords.y) * level.gridSize - playerBitmap.height; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.y = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				playerBitmap.y = (tileCoords.y ) * level.gridSize - playerBitmap.height;
				velocity.y = 0;
				isOnGround = true;
			} 
		} 
	}
	
	function checkTopCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Bottom collision
		
		if (velocity.y <= 0) 
		{//If we're falling
			
			/*Turning the player's actual coordinates to ones based on our grid
				First half of this equasion sets the collision point as the bottom of our character.
				We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	*/
			approximateCoords.y = (playerBitmap.y) / level.gridSize; 
			approximateCoords.x = (playerBitmap.x ) / level.gridSize; 
			
			tileCoords.y = Math.floor(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				playerBitmap.y = (tileCoords.y) * level.gridSize + playerBitmap.height/2; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.y = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				playerBitmap.y = (tileCoords.y ) * level.gridSize + playerBitmap.height/2;
				velocity.y = 0;
				isOnGround = true;
			} 
		} 
	}
	
	function checkRightCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Bottom collision
		
		if (velocity.x > 0) 
		{//If we're falling
			
			/*Turning the player's actual coordinates to ones based on our grid
				First half of this equasion sets the collision point as the bottom of our character.
				We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	*/
			approximateCoords.y = (playerBitmap.y + playerBitmap.height / 2) / level.gridSize; 
			approximateCoords.x = (playerBitmap.x + playerBitmap.width ) / level.gridSize; 
			
			tileCoords.y = Math.ceil(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				playerBitmap.x = (tileCoords.x) * level.gridSize - playerBitmap.width; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.x = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.y = Math.floor(approximateCoords.y);
			
			if (isBlock(tileCoords)) {
				playerBitmap.x = (tileCoords.x) * level.gridSize - playerBitmap.width ;
				velocity.x = 0;
				isOnGround = true;
			} 
		} 
		
	}
	
	function checkLeftCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Left collision
		
		if (velocity.x <= 0) 
		{//If we're moving left
			
			/*Turning the player's actual coordinates to ones based on our grid
				First half of this equasion sets the collision point as the bottom of our character.
				We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	
				*/
			approximateCoords.y = (playerBitmap.y + playerBitmap.height / 2) / level.gridSize; 
			approximateCoords.x = (playerBitmap.x - 20) / level.gridSize; 
			
			tileCoords.y = Math.floor(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				playerBitmap.x = (tileCoords.x) * level.gridSize + playerBitmap.width ; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.x = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.y = Math.ceil(approximateCoords.y);
			
			if (isBlock(tileCoords)) {
				playerBitmap.x = (tileCoords.x) * level.gridSize + playerBitmap.width ;
				velocity.x = 0;
				isOnGround = true;
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
}