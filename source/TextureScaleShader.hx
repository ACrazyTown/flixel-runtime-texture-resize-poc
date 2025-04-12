package;

import flixel.graphics.tile.FlxGraphicsShader;

/**
 * All this shader really does is apply the scale to the texture coordinates
 * this restores the original size of the sprite prior to resizing.
 * 
 * TODO: Maybe this shader could just add a new function that other shaders
 * can extend and use?
 * 
 * @author ACrazyTown
 */
class TextureScaleShader extends FlxGraphicsShader
{
    @:glFragmentSource('
    #pragma header;

    uniform float _scale;

    void main()
    {
        gl_FragColor = flixel_texture2D(bitmap, openfl_TextureCoordv * _scale);
    }
    ')

    public var scale(get, set):Float;

    public function new(?scale:Float = 1.0)
    {
        super();
        this.scale = scale;
    }

    @:noCompletion function set_scale(value:Float):Float 
    {
       _scale.value = [value];
       return value;
    }

	@:noCompletion function get_scale():Float 
    {
		return _scale.value[0];
	}
}