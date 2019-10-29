package allegro;

import js.html.AudioElement;

/// Sample object
/// Returned by load_sample().
@:native("SAMPLE_OBJECT")	
@:publicFields
extern class SAMPLE_OBJECT extends OBJECT {
	private function new(element:AudioElement, file:String, volume:Float, ready:Bool, type:String);
	/// HTML <audio> element containing the sound properties
	var element(default, null):AudioElement;
	/// sample file namee
	var file(default, null):String;
	/// sample volume, this is combined with global volume
	var volume(default, null):Float;
	/// loaded indicator flag
	var ready(default, null):Bool;
}