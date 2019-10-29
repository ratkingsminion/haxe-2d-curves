package allegro;

import js.html.Element; // correct?

/// Font object
/// Returned by load_font() and create_font(). 
@:native("FONT_OBJECT")	
@:publicFields
extern class FONT_OBJECT extends OBJECT {
	private function new(element:Element, file:String, name:String, type:String);
	/// <style> element containing the font-face declaration. Not available for create_font() fonts and default font object.
	var element(default, null):Element;
	/// font file name, empty string for default font and create_font() typefaces.
	var file(default, null):String;
	/// font-family name
	var name(default, null):String;
}