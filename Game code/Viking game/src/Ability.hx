package src;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import flash.events.Event;


/**
 * ...
 * @author Me
 */
class Ability extends Sprite
{
//	public var name : String;
//	public var type : String;	
	public var abilityBitmap : Bitmap;
	public var velocity : Point = new Point (0, 0);
	var player : Player;
	
	
	public function new() 
	{
		super ();
		
		var abilityData:BitmapData = Assets.getBitmapData( "img/ability_test.png" ); 
    	var abilityBitmap:Bitmap = new Bitmap( abilityData );
		
	//	velocity = new Point (0, 0);
		
		addChild(abilityBitmap);
		
	//	addEventListener(Event.ENTER_FRAME, everyFrame);
		trace("dololo");
	}
	
	function everyFrame(evt:Event)
	{
		trace("trololo");
		
	/*
		if (player.abilitied && !player.clicked)
		{
			x = player.x;  //Putting the ability sprite on the player
			y = player.y;
			trace("ololo");
		} 
		
		if (player.abilitied && player.clicked)
		{
			rotation = player.rotationInRadians * 180 / Math.PI;   //Rotating the ability in sprite in the right direction
		//	player.abilitySpeed = Point.polar(10, player.rotationInRadians);    //Sets the thingy to move
			x += player.abilitySpeed.x;
			y += player.abilitySpeed.y;
			if (x > 850 || y > 500  || x  <0 || y < 0)
			{
				removeChild(abilityBitmap);
			}
			trace("trololo");
		}				*/
		abilityBitmap.x += velocity.x;
		trace("wololo");
		abilityBitmap.y += velocity.y;
	}
	
	public function execute(/*type: String*/)
	{
		/* if (type == "Damage")
		{
			
		}
		
		if (type == "Movement")
		{
			
		}
		
		if (type == "Other")
		{
			
		}    */
		
		
	}
	
	
}