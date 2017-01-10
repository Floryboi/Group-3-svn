package src;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.display.BitmapData;
import openfl.display.Sprite;

/**
 * ...
 * @author Me
 */
class Ability extends Sprite
{
//	public var name : String;
//	public var type : String;	
	public var abilityBitmap : Bitmap;
	public var velocity : Point;
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