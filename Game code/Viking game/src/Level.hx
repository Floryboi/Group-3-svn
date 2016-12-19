package;

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

	var map:Array<Array<Int>>;
	var gridSize:Int;
	var block:Sprite;
	
	public function new() 
	{
		super();
		
		gridSize = 40;
		
		map = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
		[1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		];
		
		block = new Sprite();
		block.graphics.beginFill(0x3498db);
		for (row in 0...map.length) {
			for (cell in 0...map[row].length) {
				if(map[row][cell]==1){
					block.graphics.drawRect(cell * gridSize, row * gridSize, gridSize, gridSize);
				}
			}
		}
		addChild(block);
	}
	
}