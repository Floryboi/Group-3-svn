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
	
	private var gravity:Float = 1.5;
	private var jumpHeight:Float = 15.0;
	private var velocity:Point = new Point(0, 0);
	private var keys:Array<Bool>;
	private var isOnGround:Bool;
	private var jumped:Bool = false;
	private var playerBitmap:Bitmap;
	private var counter:Int = 0;
	var canSpacebar:Bool = true;
	var level : Level;
	
	//run once upon creation
	public function new() 
	{
		super();
		level = new Level();
		var playerData:BitmapData = Assets.getBitmapData( "img/Viking.png" );
    	playerBitmap = new Bitmap( playerData );
		
		playerBitmap.scaleX = 2;
		playerBitmap.scaleY = 2;
		
		addChild(playerBitmap);
		
		keys = [];
		this.addEventListener(Event.ENTER_FRAME, everyFrame);
		trace("test");
	}
	
	//Code that is run every frame
	function everyFrame(evt:Event):Void
	{
		velocity.y += gravity;
		/*
		//Ground 
		if (playerBitmap.y < 300) //When in the air
		{
			velocity.y += gravity;
			isOnGround = false;
		} 
		else //When on ground
		{
			velocity.y = 0;
			playerBitmap.y = 300;
			isOnGround = true;
		} */
		
		//Movement
		if (keys[39]) //Moving Right
		{
			playerBitmap.scaleX =  2;
			velocity.x = 7; 
			
		}
		else if (keys[37]) //Moving Left
		{
			playerBitmap.scaleX = -2;
			
			velocity.x = -7;
		}
		else //Not Moving
		{
			velocity.x = 0;
		}
		
		//Jumping
		if (keys[32] && isOnGround && !jumped ) 
		{
			velocity.y = -jumpHeight;
			jumped = true;
			//trace(jumpPress);
		}
	
		
		
		//Making so that player has to relese SPACE to jump again
		if (!keys[32] && jumped)
		{
			jumped = false;
		}
		
		var tileCoords:Point = new Point(0, 0);//Where the tile we're moving into is located based on the grid
		var approximateCoords:Point = new Point();//Where the player is located based on the level grid
		
		//Applying the velocities to the player
		playerBitmap.y += velocity.y;//Apply the y velocity to the player
		checkBottomCollision(tileCoords, approximateCoords);//Apply bottom collision
		
		playerBitmap.x += velocity.x;//Apply the x velocity to the player
		
		if (velocity.y != 0) isOnGround = false; //Infinite jumping without this, since we removed the ground check in the beginning
	}
	
	function checkBottomCollision(tileCoords:Point, approximateCoords:Point):Void 
	{//Bottom collision
		
		if (velocity.y >= 0) 
		{//If we're falling
			
			//Turning the player's actual coordinates to ones based on our grid
			approximateCoords.x = playerBitmap.x / level.gridSize;
			//trace("approximateCoords.x" + approximateCoords.x);
			approximateCoords.y = playerBitmap.y / level.gridSize;
			//trace("approximateCoords.y" + approximateCoords.y);
			
			tileCoords.y = Math.ceil(approximateCoords.y); //Round up
			//trace("tileCoords.y" + tileCoords.y);
			tileCoords.x = Math.ceil(approximateCoords.x); // Round down
			//trace("tileCoords.x" + tileCoords.x);
			
			if (isBlock(tileCoords)) { //If the tile we're going into is a block
				playerBitmap.y = (tileCoords.y ) * level.gridSize - playerBitmap.height; //Snap the player above the block
				velocity.y = 0; //Reset the player's velocity
				isOnGround = true;			
			}
			
			//We do this again because we often collide with 2 blocks at once
			/*
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				playerBitmap.y = (tileCoords.y - 1) * level.gridSize;
				velocity.y = 0;
				isOnGround = true;
			} */
		} 
	}
	
	function isBlock(coords:Point):Bool 
	{
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