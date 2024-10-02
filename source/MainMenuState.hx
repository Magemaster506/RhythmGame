import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import lime.system.System;

class MainMenuState extends FlxState {
	private var options:Array<FlxSprite>;
	private var selectedIndex:Int = 0;
	private var background:FlxSprite;

	override public function create():Void
	{
		super.create();

		// Initialize menu options as FlxSprites
		options = [];

		// Load background
		background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/menus/mainmenu/mainMenuBackground.png");
		add(background);

		// Create and add each menu option as an image
		var playSprite = new FlxSprite(0, 100).loadGraphic("assets/images/menus/mainmenu/playText.png");
		playSprite.x = (FlxG.width - playSprite.width) / 2 - 20; // Center on x-axis
		options.push(playSprite);
		add(playSprite);

		var optionsSprite = new FlxSprite(0, 200).loadGraphic("assets/images/menus/mainmenu/optionsText.png");
		optionsSprite.x = (FlxG.width - optionsSprite.width) / 2 - 20; // Center on x-axis
		options.push(optionsSprite);
		add(optionsSprite);

		var exitSprite = new FlxSprite(0, 300).loadGraphic("assets/images/menus/mainmenu/quitText.png");
		exitSprite.x = (FlxG.width - exitSprite.width) / 2 - 20; // Center on x-axis
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
		// Loop through the options and highlight the selected one
		for (i in 0...options.length)
		{
			options[i].alpha = (i == selectedIndex) ? 1 : 0.5; // Highlight selected option by adjusting transparency
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
