package;

import Curve;

// a lot of code from http://devmag.org.za/2011/04/05/bzier-curves-a-tutorial/
class BezierPath implements Curve {

	public function new() {
		
	}
	
	static function CalculateBezierPoint(t:Float, p0:Point, p1:Point, p2:Point, p3:Point):Point {
		var u = 1.0 - t;
		var tt = t*t;
		var uu = u*u;
		var uuu = uu * u;
		var ttt = tt * t;
		var p = { x:uuu * p0.x, y:uuu * p0.y }; //first term
		p.x += 3 * uu * t * p1.x; //second term
		p.y += 3 * uu * t * p1.y;
		p.x += 3 * u * tt * p2.x; //third term
		p.y += 3 * u * tt * p2.y;
		p.x += ttt * p3.x; //fourth term
		p.y += ttt * p3.y;
		return p;
	}
	
	/* INTERFACE Curve */
	/*
	public function get_points():Array<Point> {
		return _points;
	}
	
	public function get_loop():Bool {
		return _loop;
	}
	*/
	public function add(p:Point, i:Int = -1):Void {
		
	}
	
	public function remove(p:Point):Void {
		
	}
	
	public function removeAt(i:Int):Void {
		
	}
	
	public function get(t:Float):Point {
		
	}
	
	public function toggleLoop():Void {
		
	}
	
}