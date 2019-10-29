(function (console) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Curve = function() { };
Curve.__name__ = true;
Curve.prototype = {
	__class__: Curve
};
var Bezier = function(points,loop,color) {
	this.points = points;
	this.loop = loop;
	this.color = color;
	this.l = points.length;
	this.tmpL = this.l + (loop?2:0);
	var this1;
	this1 = new Array(this.tmpL);
	this.tmp = this1;
};
Bezier.__name__ = true;
Bezier.__interfaces__ = [Curve];
Bezier.prototype = {
	add: function(p,i) {
		if(i == null) i = -1;
		if(i < 0 || i > this.points.length) this.points.push(p); else this.points.splice(i,0,p);
		this.l++;
		this.tmpL++;
		if(this.tmp.length < this.tmpL) {
			var this1;
			this1 = new Array(this.tmpL);
			this.tmp = this1;
		}
	}
	,remove: function(p) {
		HxOverrides.remove(this.points,p);
		this.l = this.points.length;
		this.tmpL = this.l + (this.loop?2:0);
	}
	,removeAt: function(i) {
		this.points.splice(i,1);
		this.l--;
		this.tmpL--;
	}
	,middle: function(p1,p2) {
		return { x : p1.x + (p2.x - p1.x) * 0.5, y : p1.y + (p2.y - p1.y) * 0.5};
	}
	,get: function(t) {
		var i = this.tmpL - 1;
		if(this.loop) {
			var val = this.middle(this.points[0],this.points[this.l - 1]);
			this.tmp[0] = val;
			var val1 = this.middle(this.points[0],this.points[this.l - 1]);
			this.tmp[this.tmpL - 1] = val1;
			var _g1 = 0;
			var _g = this.l;
			while(_g1 < _g) {
				var j = _g1++;
				this.tmp[j + 1] = { x : this.points[j].x, y : this.points[j].y};
			}
		} else {
			var _g11 = 0;
			var _g2 = this.l;
			while(_g11 < _g2) {
				var j1 = _g11++;
				this.tmp[j1] = { x : this.points[j1].x, y : this.points[j1].y};
			}
		}
		while(i > 0) {
			var _g3 = 0;
			while(_g3 < i) {
				var k = _g3++;
				this.tmp[k].x = this.tmp[k].x + t * (this.tmp[k + 1].x - this.tmp[k].x);
				this.tmp[k].y = this.tmp[k].y + t * (this.tmp[k + 1].y - this.tmp[k].y);
			}
			i--;
		}
		return this.tmp[0];
	}
	,toggleLoop: function() {
		this.loop = !this.loop;
		this.tmpL = this.l + (this.loop?2:0);
		if(this.loop && this.tmp.length < this.tmpL) {
			var this1;
			this1 = new Array(this.tmpL);
			this.tmp = this1;
		}
	}
	,__class__: Bezier
};
var BezierDouble = function(points,loop,color) {
	this.points = points;
	this.loop = loop;
	this.color = color;
	this.l = points.length;
	this.tmpL = this.l * 2 + (loop?2:0);
	var this1;
	this1 = new Array(this.tmpL);
	this.tmp = this1;
};
BezierDouble.__name__ = true;
BezierDouble.__interfaces__ = [Curve];
BezierDouble.prototype = {
	add: function(p,i) {
		if(i == null) i = -1;
		if(i < 0 || i > this.points.length) this.points.push(p); else this.points.splice(i,0,p);
		this.l++;
		this.tmpL += 2;
		if(this.tmp.length < this.tmpL) {
			var this1;
			this1 = new Array(this.tmpL);
			this.tmp = this1;
		}
	}
	,remove: function(p) {
		HxOverrides.remove(this.points,p);
		this.l = this.points.length;
		this.tmpL = this.l * 2 + (this.loop?2:0);
	}
	,removeAt: function(i) {
		this.points.splice(i,1);
		this.l--;
		this.tmpL -= 2;
	}
	,middle: function(p1,p2) {
		return { x : p1.x + (p2.x - p1.x) * 0.5, y : p1.y + (p2.y - p1.y) * 0.5};
	}
	,get: function(t) {
		var i = 0;
		if(this.loop) {
			var val = this.middle(this.points[0],this.points[this.l - 1]);
			this.tmp[0] = val;
			var val1 = this.middle(this.points[0],this.points[this.l - 1]);
			this.tmp[this.tmpL - 1] = val1;
			var _g1 = 0;
			var _g = this.l;
			while(_g1 < _g) {
				var j = _g1++;
				this.tmp[j * 2 + 1] = { x : this.points[j].x, y : this.points[j].y};
			}
			var _g11 = 1;
			var _g2 = this.l + 1;
			while(_g11 < _g2) {
				var j1 = _g11++;
				var val2 = this.middle(this.points[j1 - 1],this.points[j1 % this.l]);
				this.tmp[j1 * 2] = val2;
			}
			i = this.tmpL - 1;
		} else {
			var _g12 = 0;
			var _g3 = this.l;
			while(_g12 < _g3) {
				var j2 = _g12++;
				this.tmp[j2 * 2] = { x : this.points[j2].x, y : this.points[j2].y};
			}
			var _g13 = 0;
			var _g4 = this.l - 1;
			while(_g13 < _g4) {
				var j3 = _g13++;
				var val3 = this.middle(this.points[j3],this.points[j3 + 1]);
				this.tmp[j3 * 2 + 1] = val3;
			}
			i = this.tmpL - 2;
		}
		while(i > 0) {
			var _g5 = 0;
			while(_g5 < i) {
				var k = _g5++;
				this.tmp[k].x = this.tmp[k].x + t * (this.tmp[k + 1].x - this.tmp[k].x);
				this.tmp[k].y = this.tmp[k].y + t * (this.tmp[k + 1].y - this.tmp[k].y);
			}
			i--;
		}
		return this.tmp[0];
	}
	,toggleLoop: function() {
		this.loop = !this.loop;
		this.tmpL = this.l * 2 + (this.loop?2:0);
		if(this.loop && this.tmp.length < this.tmpL) {
			var this1;
			this1 = new Array(this.tmpL);
			this.tmp = this1;
		}
	}
	,__class__: BezierDouble
};
var EditTrack = function(loop) {
	this.colorLine = window.makecolf(0.4,0.4,0.4,1);
	this.curveRes = 200;
	this.loop = loop;
	this.bmp_point = window.load_bitmap("assets/point.png");
	this.points = [];
	this.showCurves = [];
	this.showCurves.push(new Spline([],loop,window.makecolf(0.5,1,0.25,1)));
	this.showCurves.push(new Bezier([],loop,window.makecolf(1,0.5,0.25,0.95)));
	this.showCurves.push(new BezierDouble([],loop,window.makecolf(1,0.5,0.25,0.5)));
};
EditTrack.__name__ = true;
EditTrack.prototype = {
	draw: function(canvas) {
		if(this.points.length > 0) {
			var _g1 = 0;
			var _g;
			_g = this.points.length + (this.loop?1:0);
			while(_g1 < _g) {
				var i = _g1++;
				var p1 = this.points[i % this.points.length];
				window.draw_sprite(canvas,this.bmp_point,p1.x,p1.y);
				if(i > 0) {
					var p2 = this.points[i - 1];
					window.line(canvas,p2.x,p2.y,p1.x,p1.y,this.colorLine,1);
				}
			}
		}
		var _g2 = 0;
		var _g11 = this.showCurves;
		while(_g2 < _g11.length) {
			var curve = _g11[_g2];
			++_g2;
			if(curve.points.length > 1) {
				var p11 = curve.get(0.0);
				var _g3 = 1;
				var _g21 = this.curveRes + 1;
				while(_g3 < _g21) {
					var t = _g3++;
					var p21 = curve.get(js_Boot.__cast(t , Float) / this.curveRes);
					window.line(canvas,p11.x,p11.y,p21.x,p21.y,curve.color,2);
					p11 = p21;
				}
			}
		}
	}
	,movePoint: function(i,pos) {
		if(i < 0) return;
		this.points[i] = pos;
		var _g = 0;
		var _g1 = this.showCurves;
		while(_g < _g1.length) {
			var curve = _g1[_g];
			++_g;
			curve.points[i] = pos;
		}
	}
	,selectPoint: function(pos) {
		var _g1 = 0;
		var _g = this.points.length;
		while(_g1 < _g) {
			var i = _g1++;
			var s = this.points.length - i - 1;
			if(window.distance2(this.points[s].x,this.points[s].y,pos.x,pos.y) < 100) return s;
		}
		return -1;
	}
	,addPoint: function(pos) {
		var _g1 = 0;
		var _g = this.points.length - 1;
		while(_g1 < _g) {
			var i = _g1++;
			if(window.linedist(this.points[i].x,this.points[i].y,this.points[i + 1].x,this.points[i + 1].y,pos.x,pos.y) < 10) {
				var _g2 = 0;
				var _g3 = this.showCurves;
				while(_g2 < _g3.length) {
					var curve = _g3[_g2];
					++_g2;
					curve.add(pos,i + 1);
				}
				this.points.splice(i + 1,0,pos);
				return i + 1;
			}
		}
		var _g4 = 0;
		var _g11 = this.showCurves;
		while(_g4 < _g11.length) {
			var curve1 = _g11[_g4];
			++_g4;
			curve1.add(pos);
		}
		this.points.push(pos);
		return this.points.length - 1;
	}
	,removePointAt: function(i) {
		this.points.splice(i,1);
		var _g = 0;
		var _g1 = this.showCurves;
		while(_g < _g1.length) {
			var curve = _g1[_g];
			++_g;
			curve.removeAt(i);
		}
	}
	,toggleLoop: function() {
		this.loop = !this.loop;
		var _g = 0;
		var _g1 = this.showCurves;
		while(_g < _g1.length) {
			var curve = _g1[_g];
			++_g;
			curve.toggleLoop();
		}
	}
	,__class__: EditTrack
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
var Main = function() {
	this.selectedPoint = -1;
	this.h = 512;
	this.w = 512;
};
Main.__name__ = true;
Main.main = function() {
	window.addEventListener("load",($_=new Main(),$bind($_,$_.load)));
};
Main.prototype = {
	update: function() {
		if((window.mouse_b & 1) > 0 && this.selectedPoint >= 0) this.track.movePoint(this.selectedPoint,{ x : window.mouse_x, y : window.mouse_y}); else if((window.mouse_pressed & 1) > 0) {
			this.selectedPoint = this.track.selectPoint({ x : window.mouse_x, y : window.mouse_y});
			if(this.selectedPoint == -1) this.selectedPoint = this.track.addPoint({ x : window.mouse_x, y : window.mouse_y});
		} else if((window.mouse_released & 1) > 0) this.selectedPoint = -1;
		if((window.mouse_pressed & 4) > 0) {
			if(this.selectedPoint < 0) {
				var sel = this.track.selectPoint({ x : window.mouse_x, y : window.mouse_y});
				if(sel >= 0) this.track.removePointAt(sel);
			}
		}
		if(window.pressed[window.KEY_L]) this.track.toggleLoop();
	}
	,draw: function(canvas) {
		window.clear_to_color(canvas,window.makecolf(0,0,0,1));
		this.track.draw(canvas);
	}
	,ready: function() {
		var _g = this;
		window.loop(function() {
			_g.update();
			_g.draw(window.canvas);
		},window.BPS_TO_TIMER(120));
	}
	,load: function() {
		window.allegro_init_all("canvas_id",this.w,this.h,false);
		window.enable_debug("debug");
		this.track = new EditTrack(false);
		window.ready($bind(this,this.ready));
	}
	,__class__: Main
};
Math.__name__ = true;
var Spline = function(points,loop,color) {
	this.points = points;
	this.loop = loop;
	this.color = color;
	this.l = points.length;
	this.f = 1.0 / this.l;
};
Spline.__name__ = true;
Spline.__interfaces__ = [Curve];
Spline.prototype = {
	add: function(p,i) {
		if(i == null) i = -1;
		if(i < 0 || i >= this.points.length) this.points.push(p); else this.points.splice(i,0,p);
		this.l = this.points.length;
		this.f = 1.0 / this.l;
	}
	,remove: function(p) {
		HxOverrides.remove(this.points,p);
		this.l = this.points.length;
		this.f = 1.0 / this.l;
	}
	,removeAt: function(i) {
		this.points.splice(i,1);
		this.l--;
		this.f = 1.0 / this.l;
	}
	,get: function(t) {
		if(!this.loop) t = t * (1.0 - this.f);
		var i = t * this.l | 0;
		var p0 = this.points[(i - 1 + this.l) % this.l];
		var p1 = this.points[i % this.l];
		var p2 = this.points[(i + 1) % this.l];
		var p3 = this.points[(i + 2) % this.l];
		t = t * this.l - i;
		return { x : 0.5 * (2 * p1.x + t * (-p0.x + p2.x + t * (2 * p0.x - 5 * p1.x + 4 * p2.x - p3.x + t * (-p0.x + 3 * p1.x - 3 * p2.x + p3.x)))), y : 0.5 * (2 * p1.y + t * (-p0.y + p2.y + t * (2 * p0.y - 5 * p1.y + 4 * p2.y - p3.y + t * (-p0.y + 3 * p1.y - 3 * p2.y + p3.y))))};
	}
	,toggleLoop: function() {
		this.loop = !this.loop;
	}
	,__class__: Spline
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__cast = function(o,t) {
	if(js_Boot.__instanceof(o,t)) return o; else throw new js__$Boot_HaxeError("Cannot cast " + Std.string(o) + " to " + Std.string(t));
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return (Function("return typeof " + name + " != \"undefined\" ? " + name + " : null"))();
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
js_Boot.__toStr = {}.toString;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});

//# sourceMappingURL=linecar.js.map