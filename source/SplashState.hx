package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.Assets;

class SplashState extends FlxState {
    private var splashImage:FlxSprite;
    private var timer:FlxTimer;

    override public function create():Void {
        super.create();

        // Load splash screen file
        splashImage = new FlxSprite(0, 0);
		splashImage.loadGraphic("assets/images/other/customSplashScreen");
        splashImage.screenCenter();
        add(splashImage);

        // Load 1x1 mouse file 
		var cursorBitapData = Assets.getBitmapData("assets/images/other/1x1Image.png");
		FlxG.mouse.load(cursorBitapData);

        // Fade in
        splashImage.alpha = 0;
        FlxTween.tween(splashImage, {alpha: 1}, 2, {type: FlxTweenType.ONESHOT});

        // State transition timer
        timer = new FlxTimer();
        timer.start(3, function(t:FlxTimer):Void {
            FlxG.switchState(new PlayState());
        });

    }
} 