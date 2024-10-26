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
		splashImage = new FlxSprite(200, 100);
		splashImage.loadGraphic("assets/images/other/splashScreenTemp.png");
        splashImage.screenCenter();
        add(splashImage);

		// Missing texture
		var missingTexture = Assets.getBitmapData("assets/images/smallMissingTexture.png");
		FlxG.mouse.load(missingTexture);

        // Fade in
        splashImage.alpha = 0;
		FlxTween.tween(splashImage, {alpha: 1}, 2, {type: FlxTweenType.PERSIST});

        // State transition timer
        timer = new FlxTimer();
		timer.start(3, function(t:FlxTimer):Void
		{
			FlxG.switchState(new MainMenuState());
        });

    }
} 