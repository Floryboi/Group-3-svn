package src;

import openfl.Assets;
import openfl.display.Sprite;
import flash.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

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
		}
		
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
		
		var tileCoords:Point = new Point(0, 0);
		var approximateCoords:Point = new Point();
		
		//Applying the velocities to the player
		playerBitmap.y += velocity.y;
		playerBitmap.x += velocity.x;
		
	}
	/*
	function checkBottomCollision(tileCoords:Point, approximateCoords:Point):Void 
	{
		// Bottom collision
		if (velocity.y >= 0) {
			
			approximateCoords.x = playerBitmap.x / level.gridSize;
			approximateCoords.y = playerBitmap.y / level.gridSize;
			
			tileCoords.y = Math.ceil(approximateCoords.y);
        
			tileCoords.x = Math.floor(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				playerBitmap.y = (tileCoords.y - 1) * level.gridSize;
				velocity.y = 0;
				isOnGround = true;
			}
        
			tileCoords.x = Math.ceil(approximateCoords.x);
			
			if (isBlock(tileCoords)) {
				playerBitmap.y = (tileCoords.y - 1) * level.gridSize;
				velocity.y = 0;
				isOnGround = true;
			}
		}
	}
	
	function isBlock(coords:Point):Bool 
	{
		return level.map[Math.round(coords.y)][Math.round(coords.x)] == 1;
	}
	*/
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