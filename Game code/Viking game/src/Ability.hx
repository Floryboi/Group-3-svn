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
	
	public var abilityBitmap : Bitmap;
	public var velocity : Point = new Point (0, 0);
	var player : Player;
	
	
	public function new() 
	{
		super ();
		
		var abilityData:BitmapData = Assets.getBitmapData( "img/ability_test.png" ); 
    	var abilityBitmap:Bitmap = new Bitmap( abilityData );
		
		addChild(abilityBitmap);	
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