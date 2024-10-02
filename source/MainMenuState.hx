import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.system.System;

class MainMenuState extends FlxState {
	private var options:Array<FlxSprite>;
	private var selectedIndex:Int = 0;
	private var background:FlxSprite;
	private var optionYOffsets:Array<Float>;

	override public function create():Void
	{
		super.create();

		// Initialize menu options and their y-offsets
		options = [];
		optionYOffsets = [100, 200, 300]; // Default y positions for the options

		// Load background
		background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/menus/mainmenu/mainMenuBackground.png");
		add(background);

		// Create and add each menu option as an image
		var playSprite = new FlxSprite(0, optionYOffsets[0]).loadGraphic("assets/images/menus/mainmenu/playText.png");
		playSprite.x = (FlxG.width - playSprite.width) / 2 - 20;
		options.push(playSprite);
		add(playSprite);

		var optionsSprite = new FlxSprite(0, optionYOffsets[1]).loadGraphic("assets/images/menus/mainmenu/optionsText.png");
		optionsSprite.x = (FlxG.width - optionsSprite.width) / 2 - 20;
		options.push(optionsSprite);
		add(optionsSprite);

		var exitSprite = new FlxSprite(0, optionYOffsets[2]).loadGraphic("assets/images/menus/mainmenu/quitText.png");
		exitSprite.x = (FlxG.width - exitSprite.width) / 2 - 20;
		options.push(exitSprite);
		add(exitSprite);

		updateMenuGraphics();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Navigate through menu options
		if (FlxG.keys.justPressed.W)
		{
			selectedIndex = (selectedIndex - 1 + options.length) % options.length;
			updateMenuGraphics();
		}
		if (FlxG.keys.justPressed.S)
		{
			selectedIndex = (selectedIndex + 1) % options.length;
			updateMenuGraphics();
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			selectOption();
		}
	}

	private function updateMenuGraphics():Void
	{
		// Calculate target y positions for all options based on the selected one
		var centerY:Float = FlxG.height / 2 - 50; // The selected option should move here
		var offset:Float = 120; // Space between each option

		for (i in 0...options.length)
		{
			var targetY:Float;

			if (i < selectedIndex)
			{
				targetY = centerY - offset * (selectedIndex - i); // Move options above the selected one
			}
			else if (i == selectedIndex)
			{
				targetY = centerY; // Center the selected option
			}
			else
			{
				targetY = centerY + offset * (i - selectedIndex); // Move options below the selected one
			}

			// Use FlxTween to smoothly animate the y position with easing
			FlxTween.tween(options[i], {y: targetY}, 0.3, {ease: FlxEase.expoOut});

			// Adjust alpha to highlight the selected option
			options[i].alpha = (i == selectedIndex) ? 1 : 0.5;
		}
	}

	private function selectOption():Void
	{
		switch (selectedIndex)
		{
			case 0: // Play
				FlxG.switchState(new PlayState());
			case 1: // Options
				// Handle options
			case 2: // Quit
				System.exit(0);
		}
	}
}
