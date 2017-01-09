package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class Card extends Sprite		
{	
	public var color:String;
	public var symbol:String;
	public var shading:String;
	public var number:Int;

	public function new( sy:String, n:Int, c:String, sh:String)
	{
		super();
		
		//	Reading the data sent from the main function
		symbol = sy;
		number = n;
		shading = sh;
		color = c;
		
		//	Creating the correct card visuals
		var bitmapData:BitmapData = Assets.getBitmapData( "img/cards/" + number + "_" + color + "_" + shading + "_" + symbol + ".png" );
		var bitmap:Bitmap = new Bitmap( bitmapData );
		
		// Doing some visual scaling
		bitmap.scaleX = bitmap.scaleY = 2;
		
		// Setting the position to be at the middle of the card
		bitmap.x = -bitmap.width / 2;
		bitmap.y = -bitmap.height / 2;
		
		addChild( bitmap );
	}
	
}