package;

import allegro.All;
import allegro.BITMAP_OBJECT;
import Curve;

class EditTrack {
	var curveRes = 200;
	var colorLine = All.makecolf(0.4, 0.4, 0.4, 1);
	//
	var bmp_point:BITMAP_OBJECT;
	var showCurves:Array<Curve>;
	var points:Array<Point>;
	var loop:Bool;
	
	//
	
	public function draw(canvas:BITMAP_OBJECT) {
		// draw points
		if (points.length > 0) {
			for (i in 0...(points.length + (loop ? 1 : 0))) {
				var p1 = points[i % points.length];
				All.draw_sprite(canvas, bmp_point, p1.x, p1.y);
				if (i > 0) {
					var p2 = points[i - 1];
					All.line(canvas, p2.x, p2.y, p1.x, p1.y, colorLine, 1);
				}
			}
		}
		for (curve in showCurves) {
			if (curve.points.length > 1) {
				// draw lines
				var p1 = curve.get(0.0);
				for (t in 1...curveRes+1) {
					var p2 = curve.get(cast(t, Float) / curveRes);
					All.line(canvas, p1.x, p1.y, p2.x, p2.y, curve.color, 2);
					p1 = p2;
				}
			}
		}
	}
	
	public function movePoint(i:Int, pos:Point) {
		if (i < 0) {
			return;
		}
		points[i] = pos;
		for (curve in showCurves) {
			curve.points[i] = pos;
		}
	}
	
	/**
	 * Selects a point if near enough
	 * @param	pos position where to select
	 * @return	-1 if no point selected, index if selected
	 */
	public function selectPoint(pos:Point):Int {
		for (i in 0...points.length) {
			var s = points.length - i - 1;
			if (All.distance2(points[s].x, points[s].y, pos.x, pos.y) < 100) {
				return s;
			}
		}
		return -1;
	}
	
	/**
	 * adds a point, either at the end, or inbetween
	 * @param	pos position where to add
	 */
	public function addPoint(pos:Point) {
		for (i in 0...(points.length - 1)) {
			if (All.linedist(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y, pos.x, pos.y) < 10) {
				for (curve in showCurves) {
					curve.add(pos, i + 1);
				}
				points.insert(i + 1, pos);
				return i + 1;
			}
		}
		// add at end
		for (curve in showCurves) {
			curve.add(pos);
		}
		points.push(pos);
		return points.length - 1;
	}
	
	public function removePointAt(i:Int) {
		points.splice(i, 1);
		for (curve in showCurves) {
			curve.removeAt(i);
		}
	}
	
	public function toggleLoop() {
		loop = !loop;
		for (curve in showCurves) {
			curve.toggleLoop();
		}
	}

	public function new(loop:Bool) {
		this.loop = loop;
		bmp_point = All.load_bitmap("assets/point.png");
		//
		points = new Array<Point>();
		showCurves = new Array<Curve>();
		showCurves.push(new Spline([], loop, All.makecolf(0.5, 1, 0.25, 1)));
		showCurves.push(new BezierPath([], loop, All.makecolf(0.25, 0.5, 1, 1)));
		//showCurves.push(new Bezier([], loop, All.makecolf(1, 0.5, 0.25, 0.95)));
		//showCurves.push(new BezierDouble([], loop, All.makecolf(1, 0.5, 0.25, 0.5)));
	}
	
}