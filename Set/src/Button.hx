package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class Button extends Sprite
{
	//	Storing the bitmap data
	public var buttonData:BitmapData;
		
    public function new(bd:BitmapData)
    {
        super();
		
		//	Reading the bitmap data sent from the main class
		buttonData = bd;
		
		//	Creating and placing the button
		var buttonBitmap:Bitmap = new Bitmap( buttonData );
		addChild(buttonBitmap);
	}
}