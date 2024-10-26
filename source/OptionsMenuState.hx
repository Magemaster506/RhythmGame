package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class OptionsMenuState extends FlxState {

    //Images
    private var background:FlxSprite;
    private var blackOverlay:FlxSprite;

    override public function create():Void
    {
        // Background image
        background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/missingTexture.png");

        // Transition obj
        blackOverlay = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height + 200, 0xFF000000);
        add(blackOverlay);

        initialTransition();
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new MainMenuState());
		}
		if (FlxG.keys.justPressed.Q)
		{
			// test for visibility
			add(background);
		}
	}

    private function initialTransition():Void
    {
        FlxTween.tween(blackOverlay, {y: 775}, 1.8, {ease:FlxEase.expoOut});
    }


}
