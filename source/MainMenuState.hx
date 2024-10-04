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
		var playSprite = new FlxSprite(0, optionYOffsets[0]).loadGraphic("assets/images/menus/text/playUnselected.png");
		playSprite.x = (FlxG.width - playSprite.width) / 2 - 20;
		options.push(playSprite);
		add(playSprite);

		var optionsSprite = new FlxSprite(0, optionYOffsets[1]).loadGraphic("assets/images/menus/text/optionsUnselected.png");
		optionsSprite.x = (FlxG.width - optionsSprite.width) / 2 - 20;
		options.push(optionsSprite);
		add(optionsSprite);

		var exitSprite = new FlxSprite(0, optionYOffsets[2]).loadGraphic("assets/images/menus/text/quitUnselected.png");
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
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
	}

	private function updateMenuGraphics():Void
	{
		var centerY:Float = FlxG.height / 2 - 50; // The selected option should move here
		var offset:Float = 120; // Space between each option
		var selectedOffsetX:Float = 15; // X offset for the selected option
		for (i in 0...options.length)
		{
			var targetY:Float;
			var targetX:Float = (FlxG.width - options[i].width) / 2 - 20; // Initial X position

			// Update the graphic for the selected option
			if (i == selectedIndex)
			{
				options[i].loadGraphic("assets/images/menus/text/playSelected.png"); // Update with selected graphic
				targetX += selectedOffsetX; // Move selected option to the right
			}
			else
			{
				options[i].loadGraphic("assets/images/menus/text/playUnselected.png"); // Default unselected graphic
			}
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
		
			// Tween the Y and X positions with easing for smooth movement
			FlxTween.tween(options[i], {y: targetY, x: targetX}, 0.3, {ease: FlxEase.expoOut});

			// Adjust alpha to highlight the selected option
			options[i].alpha = (i == selectedIndex) ? 1 : 0.8;
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