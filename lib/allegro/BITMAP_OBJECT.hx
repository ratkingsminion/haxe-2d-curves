package allegro;

import js.html.CanvasRenderingContext2D;

/// Bitmap object
/// It's the structure of bitmap object returned from load_bitmap() and create_bitmap(). For every bitmap loaded or created, a canvas element is created. Loaded images are then drawn onto the canvas, so that you can easily manipulate images and everything is consistent. You can also load a single file two times and modify it differently for each instance.
@:native("BITMAP_OBJECT")	
@:publicFields
extern class BITMAP_OBJECT extends OBJECT {
	private function new(w:Int, h:Int, canvas:BITMAP_OBJECT, context:CanvasRenderingContext2D, ready:Bool, type:String);
	/// bitmap width
	var w(default, null):Int;
	/// bitmap height
	var h(default, null):Int;
	/// underlying canvas element, used to draw the bitmap onto stuff
	var canvas(default, null):BITMAP_OBJECT;
	/// canvas' rendering context, used to draw stuff onto this bitmap
	var context(default, null):CanvasRenderingContext2D;
	/// flags whether loading of the bitmap is complete
	var ready(default, null):Bool;
}