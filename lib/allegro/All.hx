package allegro;

import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

// allegro.js was made by Sos Sosowski
// http://allegrojs.net

@:native("window")
@:publicFields
extern class All {
	
	// CONFIGURATION ROUTINES /////////////////////////////////////////////////
	
	/// Installs allegro.
	/// This function must be called before anything else.
	static function install_allegro():Void;
	/// Wrapper for install_allegro. Installs allegro.
	/// This function must be called before anything else.
	static function allegro_init():Void;
	/// Inits Allegro and installs all subsystems.
	/// Calls install_allegro(), install_mouse(), install_timer(), install_keyboard(), install_sound() and set_gfx_mode() with provided parameters
	/// @param id drawing canvas id
	/// @param w screen width in pixels
	/// @param h screen height in pixels
	/// @param menu set this to true to enable context menu
	/// @param enable_keys array of keys that are not going to have their default action prevented, i.e. [KEY_F5] will enable reloading the website. By default, if this is omitted, function keys are the only ones on the list.
	static function allegro_init_all(id:String, w:Int, h:Int, ?menu:Bool, ?enable_keys:Array<Int>):Void;
	
	// MOUSE ROUTINES /////////////////////////////////////////////////////////
	
	/// Mouse button bitmask.
	/// Each bit in the mask represents a separate mouse button state. If right mouse button is down, mouse_b value would be 4, 00100 in binary. Each bit represents one mouse button. use something like if (mouse_b&1) to check for separate buttons.
	/// - Button 0 is LMB. (mouse_b&1)
	/// - Button 1 is MMB / wheel. (mouse_b&2)
	/// - Button 2 is RMB. (mouse_b&4)
	static var mouse_b(default, null):Int;
	/// Same as mouse_b but only checks if a button was pressed last frame
	/// Note that this only works inside loop()
	static var mouse_pressed(default, null):Int;
	/// Same as mouse_b but only checks if a button was released last frame
	/// Note that this only works inside loop()
	static var mouse_released(default, null):Int;
	/// Mouse X position within the canvas.
	static var mouse_x(default, null):Int;
	/// Mouse Y position within the canvas.
	static var mouse_y(default, null):Int;
	/// Mouse wheel position.
	/// This might not work consistently across all browsers!
	static var mouse_z(default, null):Int;
	/// Mouse mickey, X position since last loop().
	/// Only works inside loop()
	static var mouse_mx(default, null):Int;
	/// Mouse mickey, Y position since last loop().
	/// Only works inside loop()
	static var mouse_my(default, null):Int;
	/// Mouse mickey, wheel position since last loop().
	/// Only works inside loop()
	static var mouse_mz(default, null):Int;
	/// Installs mouse handlers.
	/// Must be called after set_gfx_mode() to be able to determine mouse position within the given canvas!
	/// @param menu If true, context menu will be available on right click on canvas. Default is false.
	/// @return -1 on error, 0 on success
	static function install_mouse(?menu:Bool):Int;
	/// Removes mouse handlers.
	/// @return -1 on error, 0 on success
	static function remove_mouse():Int;
	/// Enables showing system mouse cursor over canvas
	/// @return -1 on error, 0 on success
	static function show_mouse():Int;
	/// Disables system mouse cursor over canvas.
	/// Use this if you would like to provide your own cursor bitmap
	/// @return -1 on error, 0 on success
	static function hide_mouse():Int;
	
	// TIMER ROUTINES
	/// Converts seconds to install_int_ex interval units
	/// @param secs number of seconds
	/// @return value converted to milliseconds
	static function SECS_TO_TIMER(secs:Float):Float;
	/// Converts milliseconds to install_int_ex interval units
	/// @param msec number of milliseconds
	/// @return value converted to milliseconds
	static function MSEC_TO_TIMER(msecs:Int):Int;
	/// Converts beats-per-second to install_int_ex interval units
	/// @param bps number of beats per second
	/// @return value converted to milliseconds
	static function BPS_TO_TIMER(bps:Float):Float;
	/// Converts beats-per-minute to install_int_ex interval units
	/// @param bpm number of beats per minute
	/// @return value converted to milliseconds
	static function BPM_TO_TIMER(bpm:Int):Float;
	/// Does nothing.
	static function install_timer():Void;
	/// Unix time stamp!
	/// @return number of milliseconds since 1970 started.
	static function time():Int;
	/// Installs interrupt function.
	/// Installs a user timer handler, with the speed given as the number of milliseconds between ticks. This is the same thing as install_int_ex(proc, MSEC_TO_TIMER(speed)). Calling again this routine with the same timer handler as parameter allows you to adjust its speed.
	/// @param procedure function to be called
	/// @param speed execution interval in msec
	static function install_int(procedure:Void->Void, msec:Int):Void;
	/// Installs interrupt function.
	/// With this one, you must use helper functions to set the interval in the second argument. The lowest interval is 1 msec, but you probably don't want to go below 17 msec. Suggested values are BPS_TO_TIMER(30) or BPS_TO_TIMER(60). It cannot be used to alter previously installed interrupt function as well.
	/// - SECS_TO_TIMER(secs) - seconds
	/// - MSEC_TO_TIMER(msec) - milliseconds (1/1000th)
	/// - BPS_TO_TIMER(bps) - beats per second
	/// - BPM_TO_TIMER(bpm) - beats per minute
	/// @param procedure function to be called
	/// @param speed execution interval
	static function install_int_ex(procedure:Void->Void, speed:Float):Void;
	/// Game loop interrupt
	/// Loop is the same as interrupt, except, it cannot be stopped once it's started. It's meant for game loop. remove_int() and remove_all_ints() have no effect on this. Since JS can't have blocking (continuously executing) code and realise on events and timers, you cannot have your game loop inside a while or for argument. Instead, you should use this to create your game loop to be called at given interval. There should only be one loop() function! Note that mouse mickeys (mouse_mx, etc.), and pressed indicators (pressed[] and mouse_pressed) will only work inside loop()
	/// @param procedure function to be looped, preferably inline, but let's not talk coding styles here
	/// @param speed speed in the same format as install_int_ex()
	static function loop(procedure:Void->Void, speed:Float):Void;
	/// Default loading bar rendering
	/// This function is used by ready() to display a simple loading bar on screen. You need to manually specify a dummy function if you don't want loading screen.
	/// @param progress loading progress in 0.0 - 1.0 range
	static function loading_bar(progress:Float):Void;
	/// Installs a handler to check if everything has downloaded.
	/// You should always wrap your loop() function around it, unless there is nothing external you need. load_bitmap() and load_sample() all require some time to process and the execution cannot be stalled for that, so all code you wrap in this hander will only get executed after everything has loaded making sure you can access bitmap properties and data and play samples right away.  Note that load_font() does not affect ready(), so you should always load your fonts first.
	/// @param procedure function to be called when everything has loaded.
	/// @param bar loading bar callback function, if omitted, equals to loading_bar() and renders a simple loading bar. it must accept one parameter, that is loading progress in 0.0-1.0 range.
	static function ready(procedure:Void->Void, ?bar:Float->Void):Void;
	/// Removes interrupt
	/// @param procedure interrupt procedure to be removed
	static function remove_int(procedure:Void->Void):Void;
	/// Removes all interrupts
	static function remove_all_ints():Void;
	
	// KEYBOARD ROUTINES //////////////////////////////////////////////////////
		
	static var KEY_A(default, null):Int;
	static var KEY_B(default, null):Int;
	static var KEY_C(default, null):Int;
	static var KEY_D(default, null):Int;
	static var KEY_E(default, null):Int;
	static var KEY_F(default, null):Int;
	static var KEY_G(default, null):Int;
	static var KEY_H(default, null):Int;
	static var KEY_I(default, null):Int;
	static var KEY_J(default, null):Int;
	static var KEY_K(default, null):Int;
	static var KEY_L(default, null):Int;
	static var KEY_M(default, null):Int;
	static var KEY_N(default, null):Int;
	static var KEY_O(default, null):Int;
	static var KEY_P(default, null):Int;
	static var KEY_Q(default, null):Int;
	static var KEY_R(default, null):Int;
	static var KEY_S(default, null):Int;
	static var KEY_T(default, null):Int;
	static var KEY_U(default, null):Int;
	static var KEY_V(default, null):Int;
	static var KEY_W(default, null):Int;
	static var KEY_X(default, null):Int;
	static var KEY_Y(default, null):Int;
	static var KEY_Z(default, null):Int;
	static var KEY_0(default, null):Int;
	static var KEY_1(default, null):Int;
	static var KEY_2(default, null):Int;
	static var KEY_3(default, null):Int;
	static var KEY_4(default, null):Int;
	static var KEY_5(default, null):Int;
	static var KEY_6(default, null):Int;
	static var KEY_7(default, null):Int;
	static var KEY_8(default, null):Int;
	static var KEY_9(default, null):Int;
	static var KEY_0_PAD(default, null):Int;
	static var KEY_1_PAD(default, null):Int;
	static var KEY_2_PAD(default, null):Int;
	static var KEY_3_PAD(default, null):Int;
	static var KEY_4_PAD(default, null):Int;
	static var KEY_5_PAD(default, null):Int;
	static var KEY_6_PAD(default, null):Int;
	static var KEY_7_PAD(default, null):Int;
	static var KEY_8_PAD(default, null):Int;
	static var KEY_9_PAD(default, null):Int;
	static var KEY_F1(default, null):Int;
	static var KEY_ESC(default, null):Int;
	static var KEY_TILDE(default, null):Int;
	static var KEY_MINUS(default, null):Int;
	static var KEY_EQUALS(default, null):Int;
	static var KEY_BACKSPACE(default, null):Int;
	static var KEY_TAB(default, null):Int;
	static var KEY_OPENBRACE(default, null):Int;
	static var KEY_CLOSEBRACE(default, null):Int;
	static var KEY_ENTER(default, null):Int;
	static var KEY_COLON(default, null):Int;
	static var KEY_QUOTE(default, null):Int;
	static var KEY_BACKSLASH(default, null):Int;
	static var KEY_COMMA(default, null):Int;
	static var KEY_STOP(default, null):Int;
	static var KEY_SLASH(default, null):Int;
	static var KEY_SPACE(default, null):Int;
	static var KEY_INSERT(default, null):Int;
	static var KEY_DEL(default, null):Int;
	static var KEY_HOME(default, null):Int;
	static var KEY_END(default, null):Int;
	static var KEY_PGUP(default, null):Int;
	static var KEY_PGDN(default, null):Int;
	static var KEY_LEFT(default, null):Int;
	static var KEY_RIGHT(default, null):Int;
	static var KEY_UP(default, null):Int;
	static var KEY_DOWN(default, null):Int;
	static var KEY_SLASH_PAD(default, null):Int;
	static var KEY_ASTERISK(default, null):Int;
	static var KEY_MINUS_PAD(default, null):Int;
	static var KEY_PLUS_PAD(default, null):Int;
	static var KEY_ENTER_PAD(default, null):Int;
	static var KEY_PRTSCR(default, null):Int;
	static var KEY_PAUSE(default, null):Int;
	static var KEY_EQUALS_PAD(default, null):Int;
	static var KEY_LSHIFT(default, null):Int;
	static var KEY_RSHIFT(default, null):Int;
	static var KEY_LCONTROL(default, null):Int;
	static var KEY_RCONTROL(default, null):Int;
	static var KEY_ALT(default, null):Int;
	static var KEY_ALTGR(default, null):Int;
	static var KEY_LWIN(default, null):Int;
	static var KEY_RWIN(default, null):Int;
	static var KEY_MENU(default, null):Int;
	static var KEY_SCRLOCK(default, null):Int;
	static var KEY_NUMLOCK(default, null):Int;
	static var KEY_CAPSLOCK(default, null):Int;
	/// Array of flags indicating state of each key. 
	/// Available keyboard scan codes are as follows:
	/// - KEY_A ... KEY_Z,
	/// - KEY_0 ... KEY_9,
	/// - KEY_0_PAD ... KEY_9_PAD,
	/// - KEY_F1 ... KEY_F12,
	/// - KEY_ESC, KEY_TILDE, KEY_MINUS, KEY_EQUALS, KEY_BACKSPACE, KEY_TAB, KEY_OPENBRACE, KEY_CLOSEBRACE, KEY_ENTER, KEY_COLON, KEY_QUOTE, KEY_BACKSLASH, KEY_COMMA, KEY_STOP, KEY_SLASH, KEY_SPACE,
	/// - KEY_INSERT, KEY_DEL, KEY_HOME, KEY_END, KEY_PGUP, KEY_PGDN, KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN,
	/// - KEY_SLASH_PAD, KEY_ASTERISK, KEY_MINUS_PAD, KEY_PLUS_PAD, KEY_DEL_PAD, KEY_ENTER_PAD,
	/// - KEY_PRTSCR, KEY_PAUSE,
	/// - KEY_LSHIFT, KEY_RSHIFT, KEY_LCONTROL, KEY_RCONTROL, KEY_ALT, KEY_ALTGR, KEY_LWIN, KEY_RWIN, KEY_MENU, KEY_SCRLOCK, KEY_NUMLOCK, KEY_CAPSLOCK
	/// - KEY_EQUALS_PAD, KEY_BACKQUOTE, KEY_SEMICOLON, KEY_COMMAND
	static var key(default, null):Array<Bool>;
	/// Array of flags indicating in a key was just pressed since last loop()
	/// Note that this will only work inside loop()
	static var pressed(default, null):Array<Bool>;
	/// Array of flags indicating in a key was just released since last loop()
	/// Note that this will only work inside loop()
	static var released(default, null):Array<Bool>;
	/// Installs keyboard handlers
	/// Unlike mouse, keyboard can be installed before initialising graphics, and the handlers will function over the entire website, as opposed to canvas only. After this call, the key[] array can be used to check state of each key. All keys will have their default action disabled, unless specified in the enable_keys array. This means that i.e. backspace won't go back, arrows won't scroll. By default, function keys  (KEY_F1..KEY_F12) are the only ones not suppressed
	/// @param enable_keys array of keys that are not going to have their default action prevented, i.e. [KEY_F5] will enable reloading the website. By default, if this is omitted, function keys are the only ones on the list.
	/// @return -1 on error, 0 on success
	static function install_keyboard(?enable_keys:Array<Int>):Int;
	/// Uninstalls keyboard
	/// @return -1 on error, 0 on success
	static function remove_keyboard():Int;
	
	// JOYSTICK ROUTINES

	// SENSOR ROUTINES

	// TOUCH ROUTINES
	
	// BITMAP OBJECTS
	/// Creates empty bitmap.
	/// Creates a bitmap object of given dimensions and returns it.
	/// @param width bitmap width
	/// @param height bitmap height
	/// @return bitmap object
	static function create_bitmap(width:Int, height:Int):BITMAP_OBJECT;
	/// Loads bitmap from file
	/// Loads image from file asynchronously. This means that the execution won't stall for the image, and it's data won't be accessible right off the start. You can check for bitmap object's 'ready' member to see if it has loaded, but you probably should avoid stalling execution for that, as JS doesn't really like that.
	/// @param filename URL of image
	/// @return bitmap object, or -1 on error
	static function load_bitmap(filename:String):BITMAP_OBJECT;
	/// Wrapper for load_bitmap - Loads bitmap from file
	/// Loads image from file asynchronously. This means that the execution won't stall for the image, and it's data won't be accessible right off the start. You can check for bitmap object's 'ready' member to see if it has loaded, but you probably should avoid stalling execution for that, as JS doesn't really like that.
	/// @param filename URL of image
	/// @return bitmap object, or -1 on error
	static function load_bmp(filename:String):BITMAP_OBJECT;
	
	// GRAPHICS MODES
	/// Screen bitmap
	/// This is the bitmap object representing the main drawing canvas. Drawing anything on the screen bitmap displays it.
	static var canvas(default, null):BITMAP_OBJECT;
	/// Screen bitmap width in pixels
	static var SCREEN_W(default, null):Int;
	/// Screen bitmap height in pixels
	static var SCREEN_H(default, null):Int;
	/// default font
	static var font(default, null):FONT_OBJECT;
	/// Enables graphics.
	/// This function should be before calling any other graphics routines. It selects the canvas element for rendering and sets the resolution. It also loads the default font.
	/// @param canvas_id id attribute of canvas to be used for drawing.
	/// @param width canvas width in pixels
	/// @param height canvas height in pixels
	/// @return 0 on success or -1 on error
	static function set_gfx_mode(canvas_id:String, width:Int, height:Int):Int;
	
	// DRAWING PRIMITIVES
	/// Pi
	static var PI(default, null):Float;
	/// Pi/// 2
	static var PI2(default, null):Float;
	/// Pi / 2
	static var PI_2(default, null):Float;
	/// Pi / 3
	static var PI_3(default, null):Float;
	/// Pi / 4
	static var PI_4(default, null):Float;
	/// Converts degrees to radians. 
	/// Also, changes clockwise to anticlockwise.
	/// @param d value in degrees to be converted
	/// @return -d*PI/180.0f
	static function RAD(d:Float):Float;
	/// Converts radians to degrees.
	/// Also, changes anticlockwise to clockwise.
	/// @param r value in radians to be converted
	/// @return -r*180.0f/PI
	static function DEG(r:Float):Float;
	/// Creates a 0xAARRGGBB from values
	/// Overdrive is not permitted, so values over 255 (0xff) will get clipped.
	/// @param r red component in 0-255 range
	/// @param g green component in 0-255 range
	/// @param b blue  component in 0-255 range
	/// @param a alpha component in 0-255 range, defaults to 255 (fully opaque)
	/// @return colour in 0xAARRGGBB format
	static function makecol(r:Int, g:Int, b:Int, ?a:Int):Int;
	/// /// Creates 0xAARRGGBB from values
	/// This is a float version of makecol, where all components should be in 0.0-1.0 range.
	/// @param r red component in 0.0-1.0 range
	/// @param g green component in 0.0-1.0 range
	/// @param b blue  component in 0.0-1.0 range
	/// @param a alpha component in 0.0-1.0 range, defaults to 1.0 (fully opaque)
	/// @return colour in 0xAARRGGBB format
	static function makecolf(r:Float, g:Float, b:Float, ?a:Float):Int;
	/// Gets red bits from 0xRRGGBB
	/// This one does clip.
	/// @param colour colour in 0xAARRGGBB format
	/// @return red component in 0-255 range
	static function getr(colour:Int):Int;
	/// Gets red bits from 0xRRGGBB
	/// This one too.
	/// @param colour colour in 0xAARRGGBB format
	/// @return green component in 0-255 range
	static function getg(colour:Int):Int;
	/// Gets red bits from 0xRRGGBB
	/// This one clips as well.
	/// @param colour colour in 0xAARRGGBB format
	/// @return blue component in 0-255 range
	static function getb(colour:Int):Int;
	/// Gets alpha bits from 0xAARRGGBB
	/// This one doesn't.
	/// @param colour colour in 0xAARRGGBB format
	/// @return alpha component in 0-255 range
	static function geta(colour:Int):Int;
	/// Float (0.0-1.0) version of getr()
	/// @param colour colour in 0xAARRGGBB format
	/// @return red component in 0.0-1.0 range
	static function getrf(colour:Int):Float;
	/// Float (0.0-1.0) version of getg()
	/// @param colour colour in 0xAARRGGBB format
	/// @return green component in 0.0-1.0 range
	static function getgf(colour:Int):Float;
	/// Float (0.0-1.0) version of getb()
	/// @param colour colour in 0xAARRGGBB format
	/// @return blue component in 0.0-1.0 range
	static function getbf(colour:Int):Float;
	/// Float (0.0-1.0) version of geta()
	/// @param colour colour in 0xAARRGGBB format
	/// @return alpha component in 0.0-1.0 range
	static function getaf(colour:Int):Float;
	/// Gets pixel colour from bitmap
	/// Reads pixel from bitmap at given coordinates. This is probably super slow, and shouldn't be used inside loops.
	/// @param bitmap bitmap object to poll
	/// @param x x coordinate of pixel
	/// @param y y coordinate of pixel
	/// @return colour in 0xAARRGGBB format
	static function getpixel(bitmap:BITMAP_OBJECT, x:Int, y:Int):Int;
	/// Gets pixel colour from bitmap
	/// Reads pixel from bitmap at given coordinates. This is probably super slow, and shouldn't be used inside loops.
	/// @param bitmap bitmap object to update
	/// @param x x coordinate of pixel
	/// @param y y coordinate of pixel
	/// @param colour colour in 0xAARRGGBB format
	static function putpixel(bitmap:BITMAP_OBJECT, x:Int, y:Int, colour:Int):Void;
	/// Clears bitmap to transparent black.
	/// Fills the entire bitmap with 0 value, which represents transparent black.
	/// @param bitmap bitmap to be cleared
	static function clear_bitmap(bitmap:BITMAP_OBJECT):Void;
	/// Clears bitmap to specified colour.
	/// Fills the entire bitmap with colour value.
	/// @param bitmap bitmap to be cleared
	/// @param colour colour in 0xAARRGGBB format
	static function clear_to_color(bitmap:BITMAP_OBJECT, colour:Int):Void;
	/// Draws a line.
	/// Draws a line from one point to another using given colour.
	/// @param bitmap to be drawn to
	/// @param x1 start point x coordinate
	/// @param y1 start point y coordinate
	/// @param x2 end point x coordinate
	/// @param y2 end point y coordinate
	/// @param colour colour in 0xAARRGGBB format
	/// @param width line width
	static function line(bitmap:BITMAP_OBJECT, x1:Float, y1:Float, x2:Float, y2:Float, colour:Int, width:Float):Void;
	/// Draws a vertical line.
	/// Draws a vertical line from one point to another using given colour. Probably slightly faster than line() method, since this one uses rectfill() to draw the line.
	/// @param bitmap to be drawn to
	/// @param x column to draw the line to
	/// @param y1 line endpoint 1
	/// @param y2 line endpoint 2
	/// @param colour colour in 0xAARRGGBB format
	/// @param width line width (defaults to 1)
	static function vline(bitmap:BITMAP_OBJECT, x:Float, y1:Float, y2:Float, colour:Int, ?width:Float):Void;
	/// Draws a horizontal line.
	/// Draws a horizontal line from one point to another using given colour. Probably slightly faster than line() method, since this one uses rectfill() to draw the line.
	/// @param bitmap to be drawn to
	/// @param y row to draw the line to
	/// @param x1 line endpoint 1
	/// @param x2 line endpoint 2
	/// @param colour colour in 0xAARRGGBB format
	/// @param width line width (defaults to 1)
	static function hline(bitmap:BITMAP_OBJECT, x1:Float, y:Float, x2:Float, colour:Int, ?width:Float):Void;
	/// Draws a triangle.
	/// Draws a triangle using three coordinates. The triangle is not filled.
	/// @param bitmap to be drawn to
	/// @param x1 first point x coordinate
	/// @param y1 first point y coordinate
	/// @param x2 second point x coordinate
	/// @param y2 second point y coordinate
	/// @param x3 third point x coordinate
	/// @param y3 third point y coordinate
	/// @param colour colour in 0xAARRGGBB format
	/// @param width line width
	static function triangle(bitmap:BITMAP_OBJECT, x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, colour:Int, width:Float):Void;
	/// Draws a triangle.
	/// Draws a triangle using three coordinates. The triangle is filled.
	/// @param bitmap to be drawn to
	/// @param x1 first point x coordinate
	/// @param y1 first point y coordinate
	/// @param x2 second point x coordinate
	/// @param y2 second point y coordinate
	/// @param x3 third point x coordinate
	/// @param y3 third point y coordinate
	/// @param colour colour in 0xAARRGGBB format
	static function trianglefill(bitmap:BITMAP_OBJECT, x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, colour:Int):Void;
	/// Draws a polygon.
	/// Draws a polygon using three coordinates. The polygon is not filled.
	/// @param bitmap to be drawn to
	/// @param vertices number of vertices to draw
	/// @param points array containing vertices*2 elements of polygon coordinates in [x1,y1,x2,y2,x3...] format
	/// @param colour colour in 0xAARRGGBB format
	/// @param width line width
	static function polygon(bitmap:BITMAP_OBJECT, vertices:Int, points:Array<Float>, colour:Int, width:Float):Void;
	/// Draws a polygon.
	/// Draws a polygon using three coordinates. The polygon is filled.
	/// @param bitmap to be drawn to
	/// @param vertices number of vertices to draw
	/// @param points array containing vertices*2 elements of polygon coordinates in [x1,y1,x2,y2,x3...] format
	/// @param colour colour in 0xAARRGGBB format
	static function polygonfill(bitmap:BITMAP_OBJECT, vertices:Int, points:Array<Float>, colour:Int):Void;
	/// Draws a rectangle.
	/// Draws a rectangle from one point to another using given colour. The rectangle is not filled. Opposed to traditional allegro approach, width and height have to be provided, not an end point.
	/// @param bitmap to be drawn to
	/// @param x start point x coordinate
	/// @param y start point y coordinate
	/// @param w width
	/// @param h height
	/// @param colour colour in 0xAARRGGBB format
	/// @param width line width
	static function rect(bitmap:BITMAP_OBJECT, x:Float, y:Float, w:Float, h:Float, colour:Int, width:Float):Void;
	/// Draws a rectangle.
	/// Draws a rectangle from one point to another using given colour. The rectangle is filled. Opposed to traditional allegro approach, width and height have to be provided, not an end point.
	/// @param bitmap to be drawn to
	/// @param x start point x coordinate
	/// @param y start point y coordinate
	/// @param w width
	/// @param h height
	/// @param colour colour in 0xAARRGGBB format
	static function rectfill(bitmap:BITMAP_OBJECT, x:Float, y:Float, w:Float, h:Float, colour:Int):Void;
	/// Draws a circle.
	/// Draws a circle at specified centre point and radius. The circle is not filled
	/// @param bitmap to be drawn to
	/// @param x centre point x coordinate
	/// @param y centre point y coordinate
	/// @param r circle radius
	/// @param colour colour in 0xAARRGGBB format
	/// @param width line width
	static function circle(bitmap:BITMAP_OBJECT, x:Float, y:Float, radius:Float, colour:Int, width:Float):Void;
	/// Draws a circle.
	/// Draws a circle at specified centre point and radius. The circle is filled
	/// @param bitmap to be drawn to
	/// @param x centre point x coordinate
	/// @param y centre point y coordinate
	/// @param r circle radius
	/// @param colour colour in 0xAARRGGBB format
	static function circlefill(bitmap:BITMAP_OBJECT, x:Float, y:Float, radius:Float, colour:Int):Void;
	/// Draws a arc.
	/// Draws a circle at specified centre point and radius. The arc is not filled
	/// @param bitmap to be drawn to
	/// @param x centre point x coordinate
	/// @param y centre point y coordinate
	/// @param ang1 angle 1 to draw the arc between measured anticlockwise from the positive x axis in degrees
	/// @param ang2 angle 2 to draw the arc between measured anticlockwise from the positive x axis in degrees
	/// @param r radius
	/// @param colour colour in 0xAARRGGBB format
	/// @param width line width
	static function arc(bitmap:BITMAP_OBJECT, x:Float, y:Float, ang1:Float, ang2:Float, colour:Int, r:Float, width:Float):Void;
	/// Draws an arc.
	/// Draws a circle at specified centre point and radius. The arc is filled
	/// @param bitmap to be drawn to
	/// @param x centre point x coordinate
	/// @param y centre point y coordinate
	/// @param ang1 angle 1 to draw the arc between measured anticlockwise from the positive x axis in degrees
	/// @param ang2 angle 2 to draw the arc between measured anticlockwise from the positive x axis in degrees
	/// @param r radius
	/// @param colour colour in 0xAARRGGBB format
	static function arcfill(bitmap:BITMAP_OBJECT, x:Float, y:Float, ang1:Float, ang2:Float, colour:Int, r:Float):Void;
	
	// BLITTING AND SPRITES ///////////////////////////////////////////////////

	/// Draws a sprite
	/// This is probably the fastest method to get images on screen. The image will be centered. Opposed to traditional allegro approach, sprite is drawn centered.
	/// @param bmp target bitmap
	/// @param sprite sprite bitmap
	/// @param x x coordinate of the top left corder of the image center
	/// @param y y coordinate of the top left corder of the image center
	static function draw_sprite(bmp:BITMAP_OBJECT, sprite:BITMAP_OBJECT, x:Float, y:Float):Void;
	/// Draws a stretched sprite
	/// Draws a sprite stretching it to given width and height. The sprite will be centered. You can omit sy value for uniform scaling. YOu can use negative scale for flipping. Scaling is around the center.
	/// @param bmp target bitmap
	/// @param sprite sprite bitmap
	/// @param x x coordinate of the top left corder of the image
	/// @param y y coordinate of the top left corder of the image
	/// @param sx horizontal scale, 1.0 is unscaled
	/// @param sy vertical scale (defaults to sx)
	static function scaled_sprite(bmp:BITMAP_OBJECT, sprite:BITMAP_OBJECT, x:Float, y:Float, sx:Float, ?sy:Float):Void;
	/// Draws a rotated sprite
	/// Draws a sprite rotating it around its centre point. The sprite will be centred.
	/// @param bmp target bitmap
	/// @param sprite sprite bitmap
	/// @param x x coordinate of the centre of the image
	/// @param y y coordinate of the centre of the image
	/// @param angle angle of rotation in degrees
	static function rotate_sprite(bmp:BITMAP_OBJECT, sprite:BITMAP_OBJECT, x:Float, y:Float, angle:Float):Void;
	/// Draws a sprite rotated around an arbitrary point
	/// Draws a sprite rotating it around a given point. Sprite is drawn centered to the pivot point. The pivot point is relative to top-left corner of the image.
	/// @param bmp target bitmap
	/// @param sprite sprite bitmap
	/// @param x,y target coordinates of the pivot point
	/// @param cx,cy pivot point coordinates
	/// @param angle angle of rotation in degrees
	static function pivot_sprite(bmp:BITMAP_OBJECT, sprite:BITMAP_OBJECT, x:Float, y:Float, cx:Float, cy:Float, angle:Float):Void;
	/// Draws a rotated sprite and scales it
	/// Draws a sprite rotating it around its centre point. The sprite is also scaled. You can omit sy value for uniform scaling. You can use negative scale for flipping. Scaling is around the center. The sprite will be centred.
	/// @param bmp target bitmap
	/// @param sprite sprite bitmap
	/// @param x x coordinate of the centre of the image
	/// @param y y coordinate of the centre of the image
	/// @param angle angle of rotation in degrees
	/// @param sx horizontal scale, 1.0 is unscaled
	/// @param sy vertical scale (defaults to sx)
	static function rotate_scaled_sprite(bmp:BITMAP_OBJECT, sprite:BITMAP_OBJECT, x:Float, y:Float, angle:Float, sx:Float, ?sy:Float):Void;
	/// Draws a sprite rotated around an arbitrary point and scaled
	/// Draws a sprite rotating it around a given point. The sprite is also scaled. Sprite is drawn centered to the pivot point. The pivot point is relative to top-left corner of the image  before scaling. You can omit sy value for uniform scaling. You can use negative scale for flipping.
	/// @param bmp target bitmap
	/// @param sprite sprite bitmap
	/// @param x target x coordinate of the pivot point
	/// @param x target y coordinate of the pivot point
	/// @param cx pivot point x coordinate
	/// @param cx pivot point y coordinate
	/// @param angle angle of rotation in degrees
	/// @param sx horizontal scale, 1.0 is unscaled
	/// @param sy vertical scale (defaults to sx)
	static function pivot_scaled_sprite(bmp:BITMAP_OBJECT, sprite:BITMAP_OBJECT, x:Float, y:Int, cx:Float, cy:Float, angle:Float, scale:Float):Void;
	/// Blit
	/// This is how you draw backgrounds and stuff. masked_ versions are omitted, since everything is 32-bit RGBA anyways. The source and dest parameters are swapped compared to draw_sprite for historical, 20 year old reasons that must stay the same no matter what.
	/// @param source source bitmap
	/// @param dest destination bitmap
	/// @param sx source x origin
	/// @param sy source y origin
	/// @param dx top-left bitmap corner x coordinate in target bitmap
	/// @param dy top-left bitmap corner y coordinate in target bitmap
	/// @param w blit width
	/// @param h blit height
	static function blit(source:BITMAP_OBJECT, dest:BITMAP_OBJECT, sx:Int, sy:Int, dx:Int, dy:Int, w:Int, h:Int):Void;
	/// Simple Blit
	/// Simplified version of blit, works pretty much like draw_sprite but draws from the corner
	/// @param source source bitmap
	/// @param dest destination bitmap
	/// @param dx top-left bitmap corner x coordinate in target bitmap
	/// @param dy top-left bitmap corner y coordinate in target bitmap
	static function simple_blit(source:BITMAP_OBJECT, dest:BITMAP_OBJECT, x:Int, y:Int):Void;
	/// Scaled blit
	/// Draws a scaled chunk of an image on a bitmap. It's not slower.
	/// @param source source bitmap
	/// @param dest destination bitmap
	/// @param sx source x origin
	/// @param sy source y origin
	/// @param sw source width
	/// @param sh source height
	/// @param dx top-left bitmap corner x coordinate in target bitmap
	/// @param dy top-left bitmap corner y coordinate in target bitmap
	/// @param dw destination width
	/// @param dh destination height
	static function stretch_blit(source:BITMAP_OBJECT, dest:BITMAP_OBJECT, sx:Int, sy:Int, sw:Int, sh:Int, dx:Int, dy:Int, dw:Int, dh:Int):Void;
	
	// TEXT OUTPUT ////////////////////////////////////////////////////////////
	
	/// Loads font from file.
	/// This actually creates a style element, puts code inside and appends it to class. I heard it works all the time most of the time. AS ready() won't wait for fonts to load, this will allow you to have a font straight away with base64 data. Data should be WOFF converted to base64 without line breaks.
	/// @param data base64 string of a WOFF file
	/// @return font object
	static function load_base64_font(data:String):FONT_OBJECT;
	/// Loads font from file.
	/// This actually creates a style element, puts code inside and appends it to class. I heard it works all the time most of the time. Note that this function won't make ready() wait, as it's not possible to consistently tell if a font has been loaded in js, thus load your fonts first thing, and everything should be fine.
	/// @param filename Font file URL
	/// @return font object
	static function load_font(filename:String):FONT_OBJECT;
	/// Creates a font objects from font-family
	/// This creates a font element using an existing font-family name.
	/// @param family font-family property, can be 'serif', 'sans-serif' or anything else that works
	/// @return font object
	static function create_font(family:String):FONT_OBJECT;
	/// Draws text on bitmap.
	/// This draws text using given font, size and colour. You can also specify outline, or make it -1 to disable outline.
	/// @param bitmap target bitmap
	/// @param f font object
	/// @param s text string
	/// @param x x position of the text
	/// @param y y position of the text
	/// @param size font size in pixels, this not always reflects the actual glyph dimensions
	/// @param colour text colour
	/// @param outline outline colour, or omit for no outline
	/// @param width outline width
	static function textout(bitmap:BITMAP_OBJECT, f:FONT_OBJECT, s:String, x:Float, y:Float, size:Float, colour:Int, ?outline:Int, ?width:Float):Void;
	/// Draws centred text on bitmap.
	/// This draws centred text using given font, size and colour. You can also specify outline, or make it -1 to disable outline.
	/// @param bitmap target bitmap
	/// @param f font object
	/// @param s text string
	/// @param x x position of the text
	/// @param y y position of the text
	/// @param size font size in pixels, this not always reflects the actual glyph dimensions
	/// @param colour text colour
	/// @param outline outline colour, or omit for no outline
	/// @param width outline width
	static function textout_centre(bitmap:BITMAP_OBJECT, f:FONT_OBJECT, s:String, x:Float, y:Float, size:Float, colour:Int, ?outline:Int, ?width:Float):Void;
	/// Draws right-aligned text on bitmap.
	/// This draws right-aligned text using given font, size and colour. You can also specify outline, or make it -1 to disable outline.
	/// @param bitmap target bitmap
	/// @param f font object
	/// @param s text string
	/// @param x x position of the text
	/// @param y y position of the text
	/// @param size font size in pixels, this not always reflects the actual glyph dimensions
	/// @param colour text colour
	/// @param outline outline colour, or omit for no outline
	/// @param width outline width
	static function textout_right(bitmap:BITMAP_OBJECT, f:FONT_OBJECT, s:String, x:Float, y:Float, size:Float, colour:Int, ?outline:Int, ?width:Float):Void;

	// SOUND ROUTINES /////////////////////////////////////////////////////////
	
	/// Install sound
	static function install_sound():Void;
	/// Sets global volume
	static function set_volume(volume:Float):Void;
	/// Gets global volume
	static function get_volume():Float;
	/// Loads a sample from file
	/// Loads a sample from file and returns it. Doesn't stall for loading, use ready() to make sure your samples are loaded! Note that big files, such as music jingles, will most probably get streamed instead of being fully loaded into memory, meta data should be accessible tho.
	/// @param filename name of the audio file
	/// @return sample object
	static function load_sample(filename:String):SAMPLE_OBJECT;
	/// Does nothing.
	static function destroy_sample(filename:String):Void;
	/// Plays given sample.
	/// Plays a sample object using given values. Note how pan is left out, as it doesn't seem to have a js counterpart. Freq will probably not work everywhere too!
	/// @param sample sample to be played
	/// @param vol playback volume, if omitted it's 1.0
	/// @param freq speed, 1.0 is normal and used when omitted
	/// @param loop loop or not to loop, false when omitted
	static function play_sample(sample:SAMPLE_OBJECT, ?vol:Float, ?freq:Float, ?loop:Bool):Void;
	/// Adjust sample during playback
	/// Adjusts sample data Note how pan is left out, as it doesn't seem to have a js counterpart. freq will probably not work everywhere too!
	/// @param sample sample 
	/// @param vol playback volume
	/// @param freq speed, 1.0 is normal
	/// @param loop loop or not to loop
	static function adjust_sample(sample:SAMPLE_OBJECT, vol:Float, freq:Float, loop:Bool):Void;
	/// Stops playing
	/// Also resets position.
	/// @param sample sample to be stopped
	static function stop_sample(sample:SAMPLE_OBJECT):Void;
	/// Pauses playing
	/// Also doesn't reset position. Use play_sample() to resume.
	/// @param sample sample to be stopped
	static function pause_sample(sample:SAMPLE_OBJECT):Void;
	
	// HELPER MATH FUNCTIONS //////////////////////////////////////////////////
		
	/// Returns a random number from 0 to 65535
	/// Result is always integer. Use modulo (%) operator to create smaller values i.e. rand()%256 will return a random number from 0 to 255 inclusive.
	/// @return a random number in 0-65535 inclusive range
	static function rand():Int;
	/// Returns a random number from -2147483648 to 2147483647
	/// Result is always integer. Use abs() if you only want positive values.
	/// @return a random number in -2147483648-2147483648 inclusive range
	static function rand32():Int;
	/// Returns a random number from 0.0 to 1.0 (exclusive)
	/// This one is float. Use multiply (*) operator to get higher values. i.e. frand()*10 will return a value from 0.0 to 10.0
	/// @return a random floating point value from 0.0 to 1.0 (exclusive)
	static function frand():Float;
	/// Returns absolute value of a
	/// Removes minus sign from the value, should there be any.
	/// @param a value to be absoluted
	/// @return absolute value of a
	static function abs(a:Float):Float;
	/// Returns length of a vector
	/// @param x vector x coordinate
	/// @param y vector y coordinate
	/// @return length of the vector
	static function length(x:Float, y:Float):Float;
	/// Calculates distance between two points
	/// @param x1 first point x coord
	/// @param y1 first point y coord
	/// @param x2 second point x coord
	/// @param y2 second point y coord
	/// @return distance between the points
	static function distance(x1:Float, y1:Float, x2:Float, y2:Float):Float;
	/// Calculates squared distance between two points
	/// This version is just a tad faster
	/// @param x1 first point x coord
	/// @param y1 first point y coord
	/// @param x2 second point x coord
	/// @param y2 second point y coord
	/// @return squared distance between the points
	static function distance2(x1:Float, y1:Float, x2:Float, y2:Float):Float;
	/// Distance between a point and a line segment
	/// @param ex1 first x end of line segment
	/// @param ey1 first y end of line segment
	/// @param ex2 second x end of line segment
	/// @param ey2 second y end of line segment
	/// @param x point x coordinate
	/// @param y point y coordinate
	/// @return distance of point x,y from line ex1,ey1-ex2,ey2
	static function linedist(ex1:Float, ey1:Float, ex2:Float, ey2:Float, x:Float, y:Float):Float;
	/// Linear interpolation between two values
	/// Returns a value midway between from and to specified by progress
	/// @param from number to lerp from
	/// @param to number to lerp to
	/// @param progress amount of lerp
	/// @return lerped value
	static function lerp(from:Float, to:Float, progress:Float):Float;
	/// Returns a dot product of two vectors (won't be normalised)
	/// Dot product is equal to cosine of angle between two vectors times their lengths. With normalised, length 1.0, vectors, the value would be 1.0 if vectors are the same, 0.0 if they are perpendicular, and -1.0 if they point the opposite direction. It helps to determine angle differences.
	/// @param x1 vector one (x coord)
	/// @param y1 vector one (y coord)
	/// @param x2 vector two (x coord)
	/// @param y2 vector two (y coord)
	/// @return dot product of the vectors
	static function dot(x1:Float, y1:Float, x2:Float, y2:Float):Float;
	/// Returns sign of value
	/// Will return -1 if it's negative, 1 if positive and 0 if zero
	/// @param a value
	/// @return sign of a
	static function sgn(a:Float):Float;
	/// Returns an angle between two vectors
	/// @param x1 vector one (x coord)
	/// @param y1 vector one (y coord)
	/// @param x2 vector two (x coord)
	/// @param y2 vector two (y coord)
	/// @return angle in degrees, snapped to 0-360
	static function angle(x1:Float, y1:Float, x2:Float, y2:Float):Float;
	/// Returns a difference between angles
	/// @param a first angle
	/// @param b second angle
	/// @return angle difference, in -180 to 180 range
	static function anglediff(a:Float, b:Float):Float;
	/// Clamps a value
	/// Min doesn't really have to be smaller than max
	/// @param value value to be clamped
	/// @param min minimum value
	/// @param max maximum value
	/// @return clamped value
	static function clamp(value:Float, min:Float, max:Float):Float;
	/// Scales a value from one range to another
	/// @param value value to be scaled
	/// @param min1 minimum value to scale from
	/// @param max1 maximum value to scale from
	/// @param min2 minimum value to scale to 
	/// @param max2 maximum value to scale to
	/// @return scaled value
	static function scale(value:Float, min1:Float, max1:Float, min2:Float, max2:Float):Float;
	/// Scales value from one range to another and clamps it down
	/// @param value value to be scaled
	/// @param min1 minimum value to scale from
	/// @param max1 maximum value to scale from
	/// @param min2 minimum value to scale and clamp to 
	/// @param max2 maximum value to scale and clampto
	/// @return scaled and clamped value
	static function scaleclamp(value:Float, min1:Float, max1:Float, min2:Float, max2:Float):Float;
	
	// DEBUG FUNCTIONS ////////////////////////////////////////////////////////
	
	/// Set this to true if you want to debug to browser console.
	/// Setting this will make log() log to browser debugger console using console.log().
	static var ALLEGRO_CONSOLE(default, default):Bool;
	/// Enables debugging to a console.
	/// 'console' can be any html element that can accept text, preferably a <div>
	/// @param id id of the element to be the console
	static function enable_debug(id:String):Void;
	/// Logs to console
	/// Only works after enable_debug() has been called. Will append <br/> newline tag. You can use html inside your logs too.
	/// @param string text to log
	static function log(string:String):Void;
	/// Wipes the debug console
	/// Clears the debug element of any text. Useful if you want to track changing values in real time without clogging the browser. Just call it at the beginning every loop()!
	static function wipe_log():Void;
}