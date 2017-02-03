package;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class Button extends Sprite
{
	//class to make making buttons a bit easier
	public var buttonData:BitmapData;
		
    public function new(dataRef:BitmapData)
    {
        super();
		
		//reading argument
		buttonData = dataRef;
		
		//placing the bitmap
		var buttonBitmap:Bitmap = new Bitmap( buttonData );
		addChild(buttonBitmap);
	}
}