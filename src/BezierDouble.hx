package;

import allegro.All;
import haxe.ds.Vector;
import Curve;

// from http://stackoverflow.com/questions/785097/how-do-i-implement-a-b%C3%A9zier-curve-in-c
class BezierDouble implements Curve {
	public var points(default, null):Array<Point>;
	public var loop(default, null):Bool;
	public var color:Int;
	var l:Int;
	var tmpL:Int;
	var tmp:Vector<Point>;
	
	public function new(points:Array<{x:Float, y:Float}>, loop:Bool, color:Int) {
		this.points = points;
		this.loop = loop;
		this.color = color;
		l = points.length;
		tmpL = l * 2 + (loop ? 2 : 0);
		tmp = new Vector<Point>(tmpL);
	}
	
	public function add(p:Point, i:Int = -1):Void {
		if (i < 0 || i > points.length) {
			points.push(p);
		}
		else {
			points.insert(i, p);
		}
		l++;
		tmpL += 2;
		if (tmp.length < tmpL) {
			tmp = new Vector<Point>(tmpL);
		}
	}
	
	public function remove(p:Point):Void {
		points.remove(p);
		l = points.length;
		tmpL = l * 2 + (loop ? 2 : 0);
	}
	
	public function removeAt(i:Int):Void {
		points.splice(i, 1);
		l--;
		tmpL -= 2;
	}
	
	function middle(p1:Point, p2:Point):Point {
		return {
			x:(p1.x + (p2.x - p1.x) * 0.5),
			y:(p1.y + (p2.y - p1.y) * 0.5)};
	}

	public function get(t:Float):Point {
		var i = 0;
		if (loop) {
			tmp[0] = middle(points[0], points[l - 1]);
			tmp[tmpL - 1] = middle(points[0], points[l - 1]);
			for (j in 0...l) {
				tmp[j * 2 + 1] = { x:points[j].x, y:points[j].y };
			}
			for (j in 1...l + 1) {
				tmp[j * 2] = middle(points[j - 1], points[j % l]);
			}
			i = tmpL - 1;
		}
		else {
			for (j in 0...l) {
				tmp[j * 2] = { x:points[j].x, y:points[j].y };
			}
			for (j in 0...(l - 1)) {
				tmp[j * 2 + 1] = middle(points[j], points[j + 1]);
			}
			i = tmpL - 2;
		}
		while (i > 0) {
			for (k in 0...i) {
				tmp[k].x = tmp[k].x + t * (tmp[k + 1].x - tmp[k].x);
				tmp[k].y = tmp[k].y + t * (tmp[k + 1].y - tmp[k].y);
			}
			i--;
		}
		return tmp[0];
	}
	
	public function toggleLoop():Void {
		loop = !loop;
		tmpL = l * 2 + (loop ? 2 : 0);
		if (loop && tmp.length < tmpL) {
			tmp = new Vector<Point>(tmpL);
		}
	}
}