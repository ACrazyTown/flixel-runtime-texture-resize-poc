package;

import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.display.BitmapData;
import flixel.text.FlxText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;
import flixel.FlxState;

/**
 * @author ACrazyTown
 */
class PlayState extends FlxState
{
	var scaleText:FlxText;
	var infoText:FlxText;
	var flixel:FlxSprite;
	var boyfriend:FlxSprite;
	var flixel2:FlxSprite;

	// Keep original 1.0x scale graphics
	var flixelBitmap:BitmapData;
	var boyfriendBitmap:BitmapData;

	final SCALE_MIN = 0.05;
	final SCALE_MAX = 1.0;
	var scale:Float;

	override public function create():Void
	{
		super.create();
		bgColor = 0xFF7A7A7A;

		scale = SCALE_MAX;

		// Load and keep our 1.0x bitmaps we'll use when resizing.
		flixelBitmap = FlxG.assets.getBitmapData("assets/flixel.png");
		boyfriendBitmap = FlxG.assets.getBitmapData("assets/BoyFriend_Assets.png");

		// Creates all the required sprites.
		flixel = new FlxSprite(200, 0, flixelBitmap);
		flixel.screenCenter(Y);
		flixel.shader = new TextureScaleShader();
		flixel.y -= 100;
		add(flixel);

		boyfriend = new FlxSprite(700, 0);
		boyfriend.frames = FlxAtlasFrames.fromSparrow(boyfriendBitmap, "assets/BoyFriend_Assets.xml");
		boyfriend.animation.addByPrefix("loop", "BF idle dance instance", 24);
		boyfriend.animation.play("loop");
		boyfriend.screenCenter(Y);
		boyfriend.y -= 100;
		boyfriend.shader = new TextureScaleShader();
		add(boyfriend);

		final flixel2Scale:Float = FlxG.bitmap.maxTextureSize < 16384 ? 0.25 : 1;

		flixel2 = new FlxSprite(0, 0, scaleBitmapData(FlxG.assets.getBitmapData("assets/flixel.png"), flixel2Scale));
		// Evil flixel...
		flixel2.color = FlxColor.MAGENTA;
		flixel2.scale.set(0.5, 0.5);
		flixel2.updateHitbox();
		flixel2.screenCenter();
		flixel2.y += 200;
		add(flixel2);

		var flixel2Text:FlxText = new FlxText(0, 0, 0, 'This sprite will only be resized if your device\'s max texture size is less than 16384px\n(Your max texture size: ${FlxG.bitmap.maxTextureSize}px)', 16);
		flixel2Text.alignment = CENTER;
		flixel2Text.screenCenter(X);
		flixel2Text.y = flixel2.y + flixel2.height + 20;
		add(flixel2Text);

		scaleText = new FlxText(10, 10, 'Scale ($SCALE_MIN-$SCALE_MAX): ${SCALE_MAX}x', 24);
		add(scaleText);

		infoText = new FlxText(10, scaleText.y + scaleText.height, 0, 'Use LEFT & RIGHT to change scale.\nHold SHIFT to decrease by ${SCALE_MIN}x (default is ${SCALE_MIN*2}x)', 16);
		add(infoText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var offset:Float = FlxG.keys.pressed.SHIFT ? SCALE_MIN : SCALE_MIN * 2;

		if (FlxG.keys.justPressed.LEFT)
			updateScale(scale - offset);
		if (FlxG.keys.justPressed.RIGHT)
			updateScale(scale + offset);
	}

	function updateScale(newScale:Float):Void
	{
		if (newScale < SCALE_MIN)
			newScale = SCALE_MAX;
		if (newScale > SCALE_MAX)
			newScale = SCALE_MIN;

		scale = newScale;

		// Scale our sprites' textures & apply the scale to their shaders
		flixel.graphic.bitmap = scaleBitmapData(flixelBitmap, scale);
		cast (flixel.shader, TextureScaleShader).scale = scale;

		boyfriend.frames.parent.bitmap = scaleBitmapData(boyfriendBitmap, scale);
		cast (boyfriend.shader, TextureScaleShader).scale = scale;

		// Add the resized textures to the bitmap log so they can be inspected.
		FlxG.bitmapLog.clear();
		FlxG.bitmapLog.add(flixel.graphic.bitmap);
		FlxG.bitmapLog.add(boyfriend.frames.parent.bitmap);

		scaleText.text = 'Scale ($SCALE_MIN-$SCALE_MAX): ${scale}x';
	}

	function scaleBitmapData(bitmap:BitmapData, scale:Float):BitmapData
	{
		// Copy the graphic's bitmap image buffer
		var imageClone = bitmap.image.clone();

		var newWidth:Int = Std.int(imageClone.width * scale);
		var newHeight:Int = Std.int(imageClone.height * scale);

		// Resize the image buffer
		imageClone.resize(newWidth, newHeight);

		// Create new bitmap from our resized image
		return BitmapData.fromImage(imageClone);
	}
}
