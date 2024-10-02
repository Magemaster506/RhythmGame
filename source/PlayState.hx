import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.system.System;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
    private var player:Player;
    private var background:FlxSprite;
    private var npcs:Array<NPC>;
	private var pauseMenuBottom:FlxSprite;
	private var pauseMenuTop:FlxSprite;
    private var isPaused:Bool = false;

	// Pause menu variables
	private var targetYBottom:Float;
	private var targetYTop:Float;
	private var easingSpeed:Float = 8;
	private var isAnimating:Bool = false; 
	private var pauseOptions:Array<FlxSprite>; // Pause menu options
	private var selectedPauseIndex:Int = 0; // Current selection in pause menu
	private var optionYOffsets:Array<Float> = [100, 200, 300]; // Y offsets for pause menu options
	private var optionXOffset:Float = 50; // Horizontal offset relative to pauseMenuBottom

    override public function create():Void {
        super.create();
        
        // Background
        background = new FlxSprite(0, 0);
        background.loadGraphic("assets/images/background.png");
        add(background);

        // Cursor
        var cursorBitmapData = Assets.getBitmapData("assets/images/cursorDot.png");
        FlxG.mouse.load(cursorBitmapData);

        // Initialize NPCs
        npcs = [];
        var npc1 = new NPC(400, 650, "Hello!", "assets/images/characters/smallDuck.png");
        npcs.push(npc1);

        for (npc in npcs) {
            add(npc);
        }

        // Player
        player = new Player(npcs, 100, 600);
        add(player);

		// Left Pause Menu
		pauseMenuBottom = new FlxSprite(0, FlxG.height);
		pauseMenuBottom.loadGraphic("assets/images/menus/leftMenu0001.png");
		pauseMenuBottom.scrollFactor.set();
		pauseMenuBottom.visible = false;
		add(pauseMenuBottom);

		// Right Pause Menu
		pauseMenuTop = new FlxSprite(0, -FlxG.height);
		pauseMenuTop.loadGraphic("assets/images/menus/pauseMenuRight.png");
		pauseMenuTop.scrollFactor.set();
		pauseMenuTop.visible = false;
		add(pauseMenuTop);

		// Pause menu targets
		targetYBottom = FlxG.height;
		targetYTop = -FlxG.height; 
		// Create Pause Menu Options, positioned relative to `pauseMenuBottom`
		pauseOptions = [];
		var resumeSprite = new FlxSprite(optionXOffset, optionYOffsets[0]).loadGraphic("assets/images/menus/mainmenu/resumeText.png");
		resumeSprite.visible = false; // Make invisible initially
		resumeSprite.scale.set(0.8, 0.8);
		pauseOptions.push(resumeSprite);
		add(resumeSprite);

		var optionsSprite = new FlxSprite(optionXOffset, optionYOffsets[1]).loadGraphic("assets/images/menus/mainmenu/optionsText.png");
		optionsSprite.visible = false; // Make invisible initially
		pauseOptions.push(optionsSprite);
		optionsSprite.scale.set(0.8, 0.8);
		add(optionsSprite);

		var quitSprite = new FlxSprite(optionXOffset, optionYOffsets[2]).loadGraphic("assets/images/menus/mainmenu/quitText.png");
		quitSprite.visible = false; // Make invisible initially
		pauseOptions.push(quitSprite);
		quitSprite.scale.set(0.8, 0.8);
		add(quitSprite);

		updatePauseMenuGraphics();
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Toggle Fullscreen
		if (FlxG.keys.justPressed.F11)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		// Exit Game
		if (FlxG.keys.justPressed.ESCAPE)
		{
			System.exit(0);
		}

		// Toggle Pause Menu
		if (FlxG.keys.justPressed.TAB && !isPaused)
		{ // Only toggle if not paused
			togglePause();
		}
	
		if (isPaused)
		{
			// Handle navigation within pause menu
			if (FlxG.keys.justPressed.W)
			{
				selectedPauseIndex = (selectedPauseIndex - 1 + pauseOptions.length) % pauseOptions.length;
				updatePauseMenuGraphics();
			}
			if (FlxG.keys.justPressed.S)
			{
				selectedPauseIndex = (selectedPauseIndex + 1) % pauseOptions.length;
				updatePauseMenuGraphics();
			}
			if (FlxG.keys.justPressed.ENTER)
			{
				selectPauseOption();
			}
		}
		else if (player.canMove)
		{
			player.update(elapsed);
		}
	
		if (isAnimating)
		{
			// Easing function for moving the pause menus
			pauseMenuBottom.y += (targetYBottom - pauseMenuBottom.y) * easingSpeed * elapsed;
			pauseMenuTop.y += (targetYTop - pauseMenuTop.y) * easingSpeed * elapsed;

			// Update the position of pause options relative to pauseMenuBottom
			for (i in 0...pauseOptions.length)
			{
				pauseOptions[i].y = pauseMenuBottom.y + optionYOffsets[i];
				pauseOptions[i].x = optionXOffset; // Fixed X offset
			}

			if (Math.abs(pauseMenuBottom.y - targetYBottom) < 1 && Math.abs(pauseMenuTop.y - targetYTop) < 1)
			{
				// Snap to target positions
				pauseMenuBottom.y = targetYBottom;
				pauseMenuTop.y = targetYTop;

				if (!isPaused)
				{
					pauseMenuBottom.visible = false;
					pauseMenuTop.visible = false;
					// Hide options when unpaused
					for (option in pauseOptions)
					{
						option.visible = false;
					}
	
					isAnimating = false;
				}
			}
		}
	}


    private function togglePause():Void {
		isPaused = !isPaused; 

        if (isPaused) {
			// Show menus and options, start animating
			pauseMenuBottom.visible = true;
			pauseMenuTop.visible = true;
			// Make options visible
			for (option in pauseOptions)
			{
				option.visible = true;
			}
		
			player.canMove = false;
			// Move pause menus to target positions
			targetYBottom = FlxG.height - pauseMenuBottom.height;
			targetYTop = 0;
		}
		else
		{
			player.canMove = true;
			// Move pause menus back off-screen
			targetYBottom = FlxG.height;
			targetYTop = -FlxG.height;
		}
		isAnimating = true;
    }
	// Update pause menu option graphics, move selected option to center
	private function updatePauseMenuGraphics():Void
	{
		var centerY:Float = FlxG.height / 2 - 50; // The selected option should move here
		var offset:Float = 120; // Space between each option

		for (i in 0...pauseOptions.length)
		{
			var targetY:Float;

			if (i < selectedPauseIndex)
			{
				targetY = centerY - offset * (selectedPauseIndex - i); // Move options above the selected one
			}
			else if (i == selectedPauseIndex)
			{
				targetY = centerY; // Center the selected option
			}
			else
			{
				targetY = centerY + offset * (i - selectedPauseIndex); // Move options below the selected one
			}

			// Use FlxTween to smoothly animate the y position with easing
			FlxTween.tween(pauseOptions[i], {y: targetY}, 0.3, {ease: FlxEase.expoOut});

			// Adjust alpha to highlight the selected option
			pauseOptions[i].alpha = (i == selectedPauseIndex) ? 1 : 0.5;
		}
	}

	private function selectPauseOption():Void
	{
		switch (selectedPauseIndex)
		{
			case 0: // Resume
				togglePause();
			case 1: // Options
				// Handle pause menu options
			case 2: // Quit
				System.exit(0);
		}
	}
}
