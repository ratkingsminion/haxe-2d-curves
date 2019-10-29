package;

import allegro.All;
import allegro.BITMAP_OBJECT;
import Curve;
import haxe.ds.Vector;
import js.Browser;

class Main {
	var w = 512;
	var h = 512;
	var track:EditTrack;
	var selectedPoint = -1;
	var cam:Point;
	
	//

	function update() {
		if (All.mouse_b & 1 > 0 && selectedPoint >= 0) {
			track.movePoint(selectedPoint, { x:All.mouse_x, y:All.mouse_y } );
		}
		else if (All.mouse_pressed & 1 > 0) {
			selectedPoint = track.selectPoint( { x:All.mouse_x, y:All.mouse_y } );
			if (selectedPoint == -1) {
				selectedPoint = track.addPoint( { x:All.mouse_x, y:All.mouse_y } );
			}
		}
		else if (All.mouse_released & 1 > 0) {
			selectedPoint = -1;
		}
		if (All.mouse_pressed & 4 > 0) {
			if (selectedPoint < 0) {
				var sel = track.selectPoint( { x:All.mouse_x, y:All.mouse_y } );
				if (sel >= 0) {
					track.removePointAt(sel);
				}
			}
		}
		if (All.pressed[All.KEY_L]) {
			track.toggleLoop();
		}
	}
	
	function draw(canvas:BITMAP_OBJECT) {
		All.clear_to_color(canvas, All.makecolf(0, 0, 0, 1));
		
		track.draw(canvas, cam);
		
		// All.vline(bmp_back, 200, 0, h, All.makecolf(1, 1, 1, 1));
		// All.hline(bmp_back, 0, 200, w, All.makecolf(1, 1, 1, 1), 1);
		// var f = ((All.time() / 25) % 360);
		
		// All.simple_blit(bmp_back, canvas, 0, 0);
		// All.rectfill(bmp_back, 0, 0, w, h, All.makecolf(0, 0, 0, 0.01));
		// All.clear_to_color(bmp_back, All.makecolf(0, 0, 0, 0.1));
	}
	
	//
	
	function ready() {
		All.loop(function() {
			update();
			draw(All.canvas);
		}, All.BPS_TO_TIMER(120));
		
		/*
		// TEST SAVE FILE
		// from https://thiscouldbebetter.wordpress.com/2012/12/18/loading-editing-and-saving-a-text-file-in-html5-using-javascrip/
		var b = new Blob(['124'], { type:'text/plain' } );
		var dl = Browser.document.createElement("a");
		dl.setAttribute("href", URL.createObjectURL(b));
		dl.setAttribute("download", "level2.txt");
		dl.onclick = function(e:Event) { Browser.document.body.removeChild(cast(e.target, Node)); }
		dl.style.display = "none";
		Browser.document.getElementsByTagName("body")[0].appendChild(dl);
		dl.click();
		*/

		/* TEST LOAD FILE
		var h = new XMLHttpRequest();
		h.open("GET", "assets/level1.txt", true);
		h.onload = function(e:Event) {
			All.log(h.response);
		}
		h.onerror = function(e:Event) {
			All.log("error");
		}
		h.send();
		*/
	}

	function load() {
		All.allegro_init_all("canvas_id", w, h, false);
#if debug
		All.enable_debug('debug');
#end
		track = new EditTrack(false);
			
		All.ready(ready);
	}
	
	//
	
	function new() {
	}
	
	static function main() {
		Browser.window.addEventListener("load", new Main().load);
	}
}