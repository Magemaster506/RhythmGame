import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import lime.system.System;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
	// Allocations sorta
    private var player:Player;
    private var background:FlxSprite;
    private var npcs:Array<NPC>;
	private var pauseMenuBottom:FlxSprite;
	private var pauseMenuTop:FlxSprite;
	public var isPaused:Bool = false;

	// Pause menu variables and offsets
	private var targetYBottom:Float;
	private var targetYTop:Float;
	private var easingSpeed:Float = 8;
	private var isAnimating:Bool = false; 
	private var selectedPauseIndex:Int = 0; // Current selection in pause menu
	private var optionYOffsets:Array<Float> = [230, 330, 430, 530]; // Vertical offsets
	private var optionXOffsets:Array<Float> = [18, 13, 2, 28]; // Horizontal offsets
	private var animationTimer:Float = 0;
	private var animationSpeed:Float = 0.2;
	private var pauseOptions:Array<FlxSprite> = [];
	private var optionFrames:Array<Array<String>> = [];

	// quests
	private var activeQuests:Array<Quest> = [];
	private var noQuestsImage:FlxSprite; // display when the player has no active quests

	private var questNotification:QuestNotification;
	private var questNotificationIdle:QuestNotification;


	// Location Splash
	private var locationText:FlxSprite;


    override public function create():Void {
        super.create();
        
        // Background
        background = new FlxSprite(0, 0);
        background.loadGraphic("assets/images/background.png");
        add(background);

        // Cursor
		var cursorBitmapData = Assets.getBitmapData("assets/images/shared/cursorDot.png");
        FlxG.mouse.load(cursorBitmapData);

        // Initialize NPCs
        npcs = [];
		var npc1 = new NPC(400, 650, ["Hello!", "Hi", "This is the third string", "The fourth and final string"], "assets/images/characters/smallDuck.png");
		npcs.push(npc1);

		var npc1 = new NPC(600, 650, ["LINE 1", "LINE 2", "LINE 3", "LINE 4"], "assets/images/characters/bfHead.png");
        npcs.push(npc1);

        for (npc in npcs) {
            add(npc);
        }

        // Player
		player = new Player(npcs, 100, 600, this);
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

		// Initialize the no quests image
		noQuestsImage = new FlxText(FlxG.width / 2 + 50, 100);
		noQuestsImage.loadGraphic("assets/images/menus/noQuests.png");
		noQuestsImage.scrollFactor.set();
		noQuestsImage.visible = false; // Initially hidden
		add(noQuestsImage);

		// Initialize location text
		locationText = new FlxSprite(FlxG.width / 2 - 150, -FlxG.height);
		locationText.loadGraphic("assets/images/other/earthTitle.png");
		locationText.scrollFactor.set();
		add(locationText);
		FlxTween.tween(locationText, {y: 35}, 1.4, {ease: FlxEase.expoOut, onComplete: hideLocationText});

		// Initialize the quest notification
		questNotification = new QuestNotification(7, 618, [
			"assets/images/questNotification/questNotifOpen0001.png",
			"assets/images/questNotification/questNotifOpen0002.png",
			"assets/images/questNotification/questNotifOpen0003.png",
			"assets/images/questNotification/questNotifOpen0004.png",
			"assets/images/questNotification/questNotifOpen0005.png",
			"assets/images/questNotification/questNotifOpen0006.png",
			"assets/images/questNotification/questNotifOpen0007.png",
			"assets/images/questNotification/questNotifOpen0008.png",
			"assets/images/questNotification/questNotifOpen0009.png",
			"assets/images/questNotification/questNotifOpen0010.png",
			"assets/images/questNotification/questNotifOpen0011.png",
			"assets/images/questNotification/questNotifOpen0012.png",
			"assets/images/questNotification/questNotifOpen0013.png",
			"assets/images/questNotification/questNotifOpen0014.png",
			"assets/images/questNotification/questNotifOpen0015.png",
			"assets/images/questNotification/questNotifOpen0016.png"
		], [
			"assets/images/questNotification/questNotifIdle0001.png",
			"assets/images/questNotification/questNotifIdle0002.png",
			"assets/images/questNotification/questNotifIdle0003.png",
			"assets/images/questNotification/questNotifIdle0004.png",
			"assets/images/questNotification/questNotifIdle0005.png",
			"assets/images/questNotification/questNotifIdle0006.png",
			"assets/images/questNotification/questNotifIdle0007.png"
		]);

		add(questNotification);

		optionFrames = [
			[
				"assets/images/menus/text/resumeUnselected.png",
				"assets/images/menus/text/resumeSelected1.png",
				"assets/images/menus/text/resumeSelected2.png"
			],
			[
				"assets/images/menus/text/optionsUnselected.png",
				"assets/images/menus/text/optionsSelected1.png",
				"assets/images/menus/text/optionsSelected2.png"
			],
			[
				"assets/images/menus/text/mainmenuUnselected.png",
				"assets/images/menus/text/mainmenuSelected1.png",
				"assets/images/menus/text/mainmenuSelected2.png"
			],
			[
				"assets/images/menus/text/quitUnselected.png",
				"assets/images/menus/text/quitSelected1.png",
				"assets/images/menus/text/quitSelected2.png"
			]
		];

		for (i in 0...optionFrames.length)
		{
			var option = new FlxSprite(optionXOffsets[i], optionYOffsets[i]).loadGraphic(optionFrames[i][0]);
			option.visible = false;
			option.scale.set(0.8, 0.8);
			pauseOptions.push(option);
			add(option);
		}

		updatePauseMenuGraphics();
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (isPaused)
		{
			animationTimer += elapsed;
			if (animationTimer >= animationSpeed)
			{
				toggleSelectedOptionFrame();
				animationTimer = 0;
			}
		}

		// Toggle Fullscreen
		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		var dialogueActive:Bool = false;
		for (npc in npcs)
		{
			if (npc.isDialogueActive)
			{
				dialogueActive = true;
				break;
			}
		}
		if (FlxG.keys.justPressed.TAB && !dialogueActive && !isPaused)
		{
			togglePause();
		}
		// Temp Add Quest
		if (FlxG.keys.justPressed.Q)
		{
			addQuest("Find the Hidden Key", "Locate the key to open the hidden door.", "assets/images/menus/tempQuestBox.png");
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
			}

			// Update the position of noQuestsImage relative to pauseMenuTop
			noQuestsImage.y = pauseMenuTop.y + 100;

			// Animate quest boxes relative to pauseMenuTop
			for (i in 0...activeQuests.length)
			{
				var quest = activeQuests[i];
				quest.questImage.y = pauseMenuTop.y + 100 + i * 150; // Adjust to the desired offset
			}

			if (Math.abs(pauseMenuBottom.y - targetYBottom) < 1 && Math.abs(pauseMenuTop.y - targetYTop) < 1)
			{
				// Snap to target positions
				pauseMenuBottom.y = targetYBottom;
				pauseMenuTop.y = targetYTop;
				noQuestsImage.y = pauseMenuTop.y + 100;

				// Snap quest boxes to their final positions
				for (i in 0...activeQuests.length)
				{
					var quest = activeQuests[i];
					quest.questImage.y = pauseMenuTop.y + 100 + i * 150; // Final adjustment when snapping
				}

				if (!isPaused)
				{
					pauseMenuBottom.visible = false;
					pauseMenuTop.visible = false;
					noQuestsImage.visible = false;
					// Hide options and quest boxes when unpaused
					for (option in pauseOptions)
					{
						option.visible = false;
					}
					for (quest in activeQuests)
					{
						quest.questImage.visible = false;
					}
					isAnimating = false;
				}
			}
		}

	}

	private function togglePause():Void
	{
		isPaused = !isPaused; 

		if (isPaused)
		{
			// Show menus and options, start animating
			updateQuestList();
			pauseMenuBottom.visible = true;
			pauseMenuTop.visible = true;
			// Check if there are active quests
			if (activeQuests.length == 0)
			{
				noQuestsImage.visible = true; // Show 'No quests' image if no active quests
			}
			else
			{
				noQuestsImage.visible = false; // Hide 'No quests' image if there are active quests
			}

			// Make active quests visible
			for (quest in activeQuests)
			{
				quest.questImage.visible = true;
			}
			// Make sure all pause options are initialized and visible
			for (option in pauseOptions)
			{
				if (option != null)
				{ // Check if the option is not null
					option.visible = true;
				}
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
			// Hide 'No quests' image and active quests when unpaused
			noQuestsImage.visible = false;
			for (quest in activeQuests)
			{
				quest.questImage.visible = false;
			}
			// Make sure all pause options are hidden
			for (option in pauseOptions)
			{
				if (option != null)
				{ // Check if the option is not null
					option.visible = false;
				}
			}
		}
		isAnimating = true;
	}

	private function toggleSelectedOptionFrame():Void
	{
		var currentFrame = pauseOptions[selectedPauseIndex].graphic.key;
		var frameToSwitch:String;

		if (currentFrame == optionFrames[selectedPauseIndex][1])
		{
			frameToSwitch = optionFrames[selectedPauseIndex][2]; // Switch to third frame
		}
		else
		{
			frameToSwitch = optionFrames[selectedPauseIndex][1]; // Switch to second frame
		}

		pauseOptions[selectedPauseIndex].loadGraphic(frameToSwitch);
	}

	// Update pause menu option graphics, move selected option to center
	private function updatePauseMenuGraphics():Void
	{
		var centerY:Float = FlxG.height / 2 - 50; // The selected option should move here
		var offset:Float = 120; // Space between each option
		var selectedOffsetX:Float = 15; // X offset for the selected option (amount to move to the right)
		// Reset the animation timer whenever an option is highlighted
		animationTimer = 0;
		
		for (i in 0...pauseOptions.length)
		{
			var targetY:Float;
			var targetX:Float = optionXOffsets[i]; // Start with the initial X position
			// Update the graphic for the selected option immediately
			if (i == selectedPauseIndex)
			{
				pauseOptions[i].loadGraphic(optionFrames[i][1]); // Set to the selected frame immediately
			}
			else
			{
				pauseOptions[i].loadGraphic(optionFrames[i][0]); // Set to default frame when not selected
			}
		
			if (i < selectedPauseIndex)
			{
				targetY = centerY - offset * (selectedPauseIndex - i); // Move options above the selected one
			}
			else if (i == selectedPauseIndex)
			{
				targetY = centerY; // Center the selected option
				targetX += selectedOffsetX; // Move selected option to the right by adding offset
			}
			else
			{
				targetY = centerY + offset * (i - selectedPauseIndex); // Move options below the selected one
			}

			// Animate the y and x position with easing
			FlxTween.tween(pauseOptions[i], {y: targetY, x: targetX}, 0.3, {ease: FlxEase.expoOut});

			// Adjust alpha to show the selected option
			pauseOptions[i].alpha = (i == selectedPauseIndex) ? 1 : 0.8;
		}
	}


	private function selectPauseOption():Void
	{
		// Cases for pause menu
		switch (selectedPauseIndex)
		{
			case 0: // Resume
				togglePause();
			case 1: // Options
				// Handle pause menu options
			case 2: // Main Menu
				FlxG.switchState(new MainMenuState());
			case 3: // Quit
				System.exit(0);
		}
	}
	private function addQuest(title:String, description:String, imagePath:String):Void
	{
		var quest = new Quest(title, description, imagePath);
		activeQuests.push(quest);
		add(quest.questImage);
		questNotification.playAnimation();
	}

	private function updateQuestList():Void
	{
		if (activeQuests.length == 0 && isPaused == true)
		{
			noQuestsImage.visible = true;
		}
		else
		{
			noQuestsImage.visible = false;
		}

		if (isPaused == true) {}
		
		for (i in 0...activeQuests.length)
		{
			var quest = activeQuests[i];
			quest.questImage.visible = true;
			quest.questImage.x = FlxG.width - 500;
			quest.questImage.y = 100 + i * 150;
		}
	}
	private function hideLocationText(tween:FlxTween):Void
	{
		FlxTween.tween(locationText, {alpha: 0}, 1, {startDelay: 4});
	}
	
}