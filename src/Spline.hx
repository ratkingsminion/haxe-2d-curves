package;

import allegro.All;
import Curve;

// from http://wonderfl.net/c/AcjE
// catmull-rom!

class Spline implements Curve {
	public var points(default, null):Array<Point>;
	public var loop(default, null):Bool;
	public var color:Int;
	var l:Int;
	var f:Float;
	
	public function new(points:Array<{x:Float, y:Float}>, loop:Bool, color:Int) {
		this.points = points;
		this.loop = loop;
		this.color = color;
		l = points.length;
		f = 1.0 / l;
	} 
	
	public function add(p:Point, i:Int = -1):Void {
		if (i < 0 || i >= points.length) {
			points.push(p);
		}
		else {
			//if (!loop) { t = (t * (1.0 - f)); }
			points.insert(i, p);
		}
		l = points.length;
		f = 1.0 / l;
	}
	
	public function remove(p:Point):Void {
		points.remove(p);
		l = points.length;
		f = 1.0 / l;
	}
	
	public function removeAt(i:Int):Void {
		points.splice(i, 1);
		l--;
		f = 1.0 / l;
	}
	
	/* 
	* Calculates 2D cubic Catmull-Rom spline.
	* @see http://www.mvps.org/directx/articles/catmull/ 
	*/ 
	public function get(t:Float):Point  {
		if (!loop) {
			t = (t * (1.0 - f));
		}
		var i = Std.int(t * l);
		var p0 = points[(i - 1 + l) % l];
		var p1 = points[ i          % l];
		var p2 = points[(i + 1    ) % l];
		var p3 = points[(i + 2    ) % l];
		t = t * l - i;
		return {
			x:0.5 * ((        2*p1.x) +
				t * (( -p0.x           +p2.x) +
				t * ((2*p0.x -5*p1.x +4*p2.x -p3.x) +
				t * (  -p0.x +3*p1.x -3*p2.x +p3.x)))),
			y:0.5 * ((        2*p1.y) +
				t * (( -p0.y           +p2.y) +
				t * ((2*p0.y -5*p1.y +4*p2.y -p3.y) +
				t * (  -p0.y +3*p1.y -3*p2.y +p3.y))))
		};
	}
	
	public function toggleLoop():Void {
		loop = !loop;
	}
}