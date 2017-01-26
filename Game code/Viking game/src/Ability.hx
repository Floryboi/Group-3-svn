package src;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.geom.Point;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import flash.events.Event;

import openfl.display.Tile;
import openfl.display.Tileset;
import openfl.display.Tilemap;

import flash.geom.Rectangle;

class Ability extends Sprite
{
	
	public var abilityBitmap : Bitmap;
	public var velocity : Point = new Point (0, 0);
	
	// the TileSheet instance containing the sprite sheet
	var tileSet:Tileset;

	public var tilemap:Tilemap;

	// the variable determining the frame rate of the animations
	static inline var fps:Int = 6;

	// calculates the milliseconds every frame should be visible (based on fps above)
	var fpsPerFrame:Int = 5;

	// the total amount of frames in the sprite sheet (used to define all frame rectangles)
	static inline var frameCount:Int = 9;

	// time measurement to get the proper frame rate
	var currentDuration:Int = 0;
	var currentFrame = 1;

	// the arrays containing the frame numbers of the animations in the sprite sheet
	var sequence:Array<Int> = [1, 2, 3, 4, 5, 6, 7, 8, 9];

	// the current animation. one of the above sequences will be referenced by this variable.
	var currentStateFrames:Array<Int>;
	
	public function new() 
	{
		super ();
		
		var abilityData:BitmapData = Assets.getBitmapData( "img/abilitySheet.png" ); 
    	tileSet = new Tileset( abilityData );
		
		tilemap = new Tilemap( 192, 192, tileSet );
		
		initializeSpriteSheet();
		
		tilemap.addTile( new Tile( 1 ) );
		
		tilemap.scaleX = tilemap.scaleY = .2;
		
		addChild( tilemap );
		
		currentStateFrames = sequence;
	}
	
	private function initializeSpriteSheet()
	{
		// this sprite sheet is a single row. Easy loop...
		// accidentally it's a PoT (power of two) size (512x32 px here)
		// individual frames are 32x32 px
		for (i in 0 ... frameCount) 
		{
			tileSet.addRect( new Rectangle ( i * (192+1), 0, 192, 192 ) );
		}
	}

	public function toggleAnimation()
	{
		currentStateFrames = sequence;
		currentFrame = 0;
		currentDuration = 0;
	}
	
	public function everyFrame()
	{
		currentDuration++;
		
		if( currentDuration > fpsPerFrame )
		{
			currentDuration -= fpsPerFrame;
			currentFrame++;
			
			if( currentFrame >= currentStateFrames.length ) currentFrame = 0;
			
			tilemap.removeTile( tilemap.getTileAt( 0 ) );
			tilemap.addTile( new Tile( currentStateFrames[currentFrame] ) );
		}
	}
	
}