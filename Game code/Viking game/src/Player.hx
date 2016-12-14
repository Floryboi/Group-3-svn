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
	private var velocity:Point = new Point(0, 0);
	private var keys:Array<Bool>;
	private var isOnGround:Bool;
	private var jumped:Bool = false;
	private var playerBitmap:Bitmap;
	private var counter:Int = 0;
	
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
	}
	
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
			playerBitmap.x = playerBitmap.x - playerBitmap.width / 2;
			velocity.x = -7;
		}
		else //Not Moving
		{
			velocity.x = 0;
		}
		
		//Jumping
		if (keys[32] && isOnGround && !jumped ) 
		{
			velocity.y = -13;
			//jumped = true;
			//trace(jumpPress);
		}
		
		/*
		if (jumped) //Counting time in the air
		{
			counter++;
		}
		
		if (counter > 120) //Jump delay
		{
			counter = 0;
			jumped = false;
		}
		*/
		
		//Applying the velocities to the player
		playerBitmap.y += velocity.y;
		playerBitmap.x += velocity.x;
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