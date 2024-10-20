package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.system.System;

class MainMenuState extends FlxState
{
    private var options:Array<FlxSprite>;
	private var background:FlxSprite;
    private var selectedIndex:Int = 0;
    private var animationTimer:Float = 0;
    private var animationSpeed:Float = 0.2; // Time between frame changes
	private var blackOverlay:FlxSprite;

    private var optionFrames:Array<Array<String>> = [
        [
            "assets/images/menus/text/playUnselected.png",
            "assets/images/menus/text/playSelected1.png",
            "assets/images/menus/text/playSelected2.png"
        ],
        [
            "assets/images/menus/text/optionsUnselected.png",
			"assets/images/menus/text/options/optionsSelected1.png",
			"assets/images/menus/text/options/optionsSelected2.png"
        ],
        [
            "assets/images/menus/text/quitUnselected.png",
            "assets/images/menus/text/quitSelected1.png",
            "assets/images/menus/text/quitSelected2.png"
        ]
    ];

    override public function create():Void
	{
		background = new FlxSprite(0, 0);
		background.loadGraphic("assets/images/menus/mainmenu/mainMenuBackground.png");
		add(background);

		// Create black overlay for transition effect
        
        // Add options to the menu
        options = [];
        var centerY:Float = FlxG.height / 2 - 50;
        var offset:Float = 120;

        for (i in 0...optionFrames.length)
		{
			var option:FlxSprite = new FlxSprite();
			option.loadGraphic(optionFrames[i][0]); // Set the unselected frame initially
			option.screenCenter();
			option.y = centerY + offset * i;
			option.alpha = (i == selectedIndex) ? 1 : 0.8;
			options.push(option);
			add(option);
		}

		// Update the initial menu graphics
		updateMenuGraphics();
		// Transition obj
		blackOverlay = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height + 200, 0xFF000000);
		add(blackOverlay);

		initialTransition();
	}

	private function initialTransition():Void
	{
		FlxTween.tween(blackOverlay, {y: 775}, 1.8, {ease: FlxEase.expoOut});
	
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        animationTimer += elapsed;
        if (animationTimer >= animationSpeed)
        {
            toggleSelectedOptionFrame();
            animationTimer = 0;
        }

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

    private function toggleSelectedOptionFrame():Void
    {
        var currentFrame = options[selectedIndex].graphic.key;
        var frameToSwitch:String;

        // Switch between the two selected frames
        if (currentFrame == optionFrames[selectedIndex][1])
        {
            frameToSwitch = optionFrames[selectedIndex][2];
        }
        else
        {
            frameToSwitch = optionFrames[selectedIndex][1];
        }

        options[selectedIndex].loadGraphic(frameToSwitch);
    }

    private function updateMenuGraphics():Void
    {
        var centerY:Float = FlxG.height / 2 - 50;
        var offset:Float = 120;

        // Reset the animation timer when a new option is selected
        animationTimer = 0;

        for (i in 0...options.length)
        {
            var targetY:Float;

            // Update the graphic based on whether the option is selected
            if (i == selectedIndex)
            {
                options[i].loadGraphic(optionFrames[i][1]); // Set to the first selected frame immediately

            }
            else
            {
                options[i].loadGraphic(optionFrames[i][0]); // Set to unselected frame
            }

            // Calculate Y position
            if (i < selectedIndex)
            {
                targetY = centerY - offset * (selectedIndex - i);
            }
            else if (i == selectedIndex)
            {
                targetY = centerY;
            }
            else
            {
                targetY = centerY + offset * (i - selectedIndex);
            }

            // Tween the Y and X positions with easing
            FlxTween.tween(options[i], {y: targetY}, 0.3, {ease: FlxEase.expoOut});

            // Adjust alpha to highlight the selected option
            options[i].alpha = (i == selectedIndex) ? 1 : 0.8;
        }
    }

    private function selectOption():Void
    {
		// Play transition animation before switching state
		FlxTween.tween(blackOverlay, {y: -9}, 1.2, {ease: FlxEase.expoOut, onComplete: waitTransition});
	}

	private function waitTransition(tween:FlxTween):Void
	{
		FlxTween.tween(blackOverlay, {y: -30}, 0.8, {ease: FlxEase.expoOut, onComplete: onTransitionComplete});
	}

	private function onTransitionComplete(tween:FlxTween):Void
	{
        switch (selectedIndex)
        {
            case 0:
                // Handle "Play"
                FlxG.switchState(new PlayState());
            case 1:
                // Handle "Options"
                trace("Options selected");
            case 2:
                // Handle "Quit"
				System.exit(0);
        }
    }
}
