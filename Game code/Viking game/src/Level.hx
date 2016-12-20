package src;

import openfl.Assets;
import openfl.display.Sprite;
//import flash.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;

class Level extends Sprite
{

	public var map:Array<Array<Int>>;
	public var gridSize:Int;
	var block:Sprite;
	
	public function new() 
	{
		super();
		
		gridSize = 32;
		
		var blockBitmap:Bitmap;
		var blockData:BitmapData = Assets.getBitmapData( "img/block.png" );
		blockBitmap = new Bitmap( blockData );
		
		map = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]];
		
		block = new Sprite();
		block.graphics.beginFill(0x3498db);
		for (row in 0...map.length) {
			for (coll in 0...map[row].length) {
				if (map[row][coll] == 1){
					//block.graphics.drawRect(coll * gridSize, row * gridSize, gridSize, gridSize);
					var blockData:BitmapData = Assets.getBitmapData( "img/block.png" );
					blockBitmap = new Bitmap( blockData );
					blockBitmap.x = coll * gridSize;
					blockBitmap.y = row * gridSize;
					block.addChild(blockBitmap);
				}
			}
		}
		addChild(block);
	}
	
}