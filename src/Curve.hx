package;

typedef Point = { x:Float, y:Float };

interface Curve {
	public var points(default, null):Array<Point>;
	public var loop(default, null):Bool;
	public var color:Int;
	
	// public function new(points:Array<{x:Float, y:Float}>, loop:Bool);
	public function add(p:Point, i:Int = -1):Void;
	public function remove(p:Point):Void;
	public function removeAt(i:Int):Void;
	public function get(t:Float):Point;
	public function toggleLoop():Void;
}