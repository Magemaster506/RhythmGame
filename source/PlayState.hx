import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import lime.system.System;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
    private var player:Player;
    private var background:FlxSprite;
    private var npcs:Array<NPC>;
    private var pauseMenu:FlxSprite;
    private var isPaused:Bool = false;

	// Pause menu variables
	private var targetY:Float;
	private var easingSpeed:Float = 5;
	private var isAnimating:Bool = false; 

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

		// Pause Menu - Starts offscreen
		pauseMenu = new FlxSprite(0, -FlxG.height);
		pauseMenu.loadGraphic("assets/images/other/pauseMenuTemp.png");
		// pauseMenu.makeGraphic(Std.int(FlxG.width / 2 - 150), FlxG.height, 0xBA000000);
		pauseMenu.scrollFactor.set();
		pauseMenu.visible = false; 
        add(pauseMenu);
		targetY = -FlxG.height; 
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Toggle Fullscreen
        if (FlxG.keys.justPressed.F11) {
            FlxG.fullscreen = !FlxG.fullscreen;
        }

        // Exit Game
        if (FlxG.keys.justPressed.ESCAPE) {
			FlxG.switchState(new MainMenuState());
			// System.exit(0);
        }

        // Toggle Pause Menu
        if (FlxG.keys.justPressed.TAB) {
            togglePause();
        }

		if (player.canMove)
		{
            player.update(elapsed);
        }

		if (isAnimating)
		{
			// Easing function for moving the pause menu
			pauseMenu.y += (targetY - pauseMenu.y) * easingSpeed * elapsed;

			if (Math.abs(pauseMenu.y - targetY) < 1)
			{
				pauseMenu.y = targetY; // Snap to target position
				if (!isPaused)
				{
					pauseMenu.visible = false;
					isAnimating = false;
                }
            }
        }
    }

    private function togglePause():Void {
        isPaused = !isPaused; // Toggle paused state

        if (isPaused) {
			pauseMenu.visible = true;
			player.canMove = false;
			targetY = 0; 
        } else {
			player.canMove = true;
			targetY = -FlxG.height; 
        }
		isAnimating = true; // Start the animation
    }
}
