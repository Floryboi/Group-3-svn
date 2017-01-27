package src;

import openfl.Assets;
import openfl.display.Sprite;
import flash.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.geom.Point;
//import openfl.display.Bitmap;
import openfl.display.BitmapData;
import src.Level;
import src.Ability;
import openfl.Lib;

import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.display.Tilemap;

import flash.geom.Rectangle;

class Player extends Sprite
{
	var slowdown: Float = .5;
	var speed : Float = 2;
	private var jumpHeight:Float = 15.0;
	public var velocity:Point = new Point(0, 0); // Variable where we store the velocity to be added to the player. This is applied at the end of every frame loop.
	public var keys:Array<Bool>; //Array in which we store the keyboard keys and their values for pressed or not.
	private var isOnGround:Bool; //Are we colliding?
	private var jumped:Bool = false; //To keep track if we're in the air from a jump
	//public var tilemap:Bitmap;
	var canSpacebar:Bool = true; //Can we press spacebar again? So we don't do the infinte hop
	var level : Level; //Referencing the level class, so we can read from it
	//var enemy : Enemy;
	
	var timer : Int = 0;
	
	// the TileSheet instance containing the sprite sheet
	var tileSet:Tileset;

	public var tilemap:Tilemap;

	// the variable determining the frame rate of the animations
	static inline var fps:Int = 12;

	// calculates the milliseconds every frame should be visible (based on fps above)
	var fpsPerFrame:Int = 5;

	// the total amount of frames in the sprite sheet (used to define all frame rectangles)
	static inline var frameCount:Int = 4;

	// time measurement to get the proper frame rate
	var currentDuration:Int = 0;
	var currentFrame = 1;

	// the arrays containing the frame numbers of the animations in the sprite sheet
	var sequence:Array<Int> = [1, 2, 3, 4];

	// the current animation. one of the above sequences will be referenced by this variable.
	var currentStateFrames:Array<Int>;
		
	//run once upon creation
	public function new()
	{
		super();
		
		level = new Level(); //Reference to the level
		
		//Assigning the player's texture
		var playerData:BitmapData = Assets.getBitmapData( "img/vikingWalk.png" ); 
    	tileSet = new Tileset( playerData );
		
		tilemap = new Tilemap( 64, 64, tileSet );
		
		initializeSpriteSheet();
		
		tilemap.addTile( new Tile( 1 ) );
			
		addChild( tilemap );
		
		currentStateFrames = sequence;
		
		keys = []; //Defining the array we use to store the keyboard keys. It's empty because it's populated by the respective functions
		
		this.addEventListener(Event.ENTER_FRAME, everyFrame); //The game is frame based, so we're tracking things that happen every frame in the everyFrame function
	}
	
	private function initializeSpriteSheet()
	{
		// this sprite sheet is a single row. Easy loop...
		// accidentally it's a PoT (power of two) size (512x32 px here)
		// individual frames are 32x32 px
		for (i in -1 ... frameCount) 
		{
			tileSet.addRect( new Rectangle ( i * (64), 0, 64, 64 ) );
		}
	}

	public function toggleAnimation()
	{
		currentStateFrames = sequence;
		currentFrame = 0;
		currentDuration = 0;
	}
	
	//Code that is run every frame
	function everyFrame(evt:Event):Void
	{		
		
		//Movement
		if (keys[68]) //Moving Right
		{
			if (velocity.x < 7) velocity.x += speed; //Movement speed
		}
		if (keys[65]) //Moving Left
		{
			if (velocity.x > -7) velocity.x -= speed; //Movement speed
		}
		if (keys[83]) //Moving Down
		{
			if (velocity.y < 7) velocity.y += speed; //Movement speed
		}
		if (keys[87]) //Moving Up
		{
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
		
		
		if (tilemap.y >= stage.height + 80) tilemap.y = stage.height + 80;
		if (tilemap.y <= 10) tilemap.y = 10;
		if (tilemap.x <= 10) tilemap.x = 10;
		if (tilemap.x >= stage.width - 60) tilemap.x = stage.width - 60;
		
		
		//Applying the velocities to the player
		tilemap.y += velocity.y;	//Apply the y velocity to the player
		checkBottomCollision(tileCoords, approximateCoords);	//Apply bottom collision
		checkTopCollision(tileCoords, approximateCoords);
		
		tilemap.x += velocity.x;	//Apply the x velocity to the player
		checkRightCollision(tileCoords, approximateCoords);
		checkLeftCollision(tileCoords, approximateCoords);
		
		if (velocity.y != 0) isOnGround = false; //Infinite jumping without this, since we removed the ground check in the beginning
		
		currentDuration++;
		
		if( currentDuration > fpsPerFrame )
		{
			currentDuration -= fpsPerFrame;
			currentFrame++;
			
			if( currentFrame >= currentStateFrames.length ) currentFrame = 0;
			
			tilemap.removeTile( tilemap.getTileAt( 0 ) );
			tilemap.addTile( new Tile( currentStateFrames[currentFrame] ) );
		}
		
	}
	

	
	
	function checkBottomCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Bottom collision
		
		if (velocity.y >= 0) 
		{//If we're falling
			
			/*Turning the player's actual coordinates to ones based on our grid
				First half of this equasion sets the collision point as the bottom of our character.
				We then divide it by the gridsize to turn it into a value relative to our grid, so we can compare it to the blocks later.	*/
			approximateCoords.y = (tilemap.y + tilemap.height / 2 ) / level.gridSize; 
			approximateCoords.x = (tilemap.x ) / level.gridSize; 
			
			tileCoords.y = Math.ceil(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				tilemap.y = (tileCoords.y) * level.gridSize - tilemap.height; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.y = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				tilemap.y = (tileCoords.y ) * level.gridSize - tilemap.height;
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
			approximateCoords.y = (tilemap.y) / level.gridSize; 
			approximateCoords.x = (tilemap.x ) / level.gridSize; 
			
			tileCoords.y = Math.floor(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				tilemap.y = (tileCoords.y) * level.gridSize + tilemap.height/2; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.y = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				tilemap.y = (tileCoords.y ) * level.gridSize + tilemap.height/2;
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
			approximateCoords.y = (tilemap.y + tilemap.height / 2) / level.gridSize; 
			approximateCoords.x = (tilemap.x + tilemap.width ) / level.gridSize; 
			
			tileCoords.y = Math.ceil(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				tilemap.x = (tileCoords.x) * level.gridSize - tilemap.width; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.x = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.y = Math.floor(approximateCoords.y);
			
			if (isBlock(tileCoords)) {
				tilemap.x = (tileCoords.x) * level.gridSize - tilemap.width ;
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
			approximateCoords.y = (tilemap.y + tilemap.height / 2) / level.gridSize; 
			approximateCoords.x = (tilemap.x - 32) / level.gridSize; 
			
			tileCoords.y = Math.floor(approximateCoords.y); 
			tileCoords.x = Math.floor(approximateCoords.x); 
			//Round up, which is actually down on the screen, so the bottom of the block the player is in, which is the top of the block we're coliding with
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				tilemap.x = (tileCoords.x) * level.gridSize + tilemap.width ; //Snap the player above the block. The weird math is to say how much above the block
				
				velocity.x = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			
			tileCoords.y = Math.ceil(approximateCoords.y);
			
			if (isBlock(tileCoords)) {
				tilemap.x = (tileCoords.x) * level.gridSize + tilemap.width ;
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