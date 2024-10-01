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
	private var pauseMenuBottom:FlxSprite;
	private var pauseMenuTop:FlxSprite;
    private var isPaused:Bool = false;

	// Pause menu variables
	private var targetYBottom:Float;
	private var targetYTop:Float;
	private var easingSpeed:Float = 8;
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

		// Left Pause Menu
		pauseMenuBottom = new FlxSprite(0, FlxG.height);
		pauseMenuBottom.loadGraphic("assets/images/menus/pauseMenuLeft.png");
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
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Toggle Fullscreen
        if (FlxG.keys.justPressed.F11) {
            FlxG.fullscreen = !FlxG.fullscreen;
        }

        // Exit Game
        if (FlxG.keys.justPressed.ESCAPE) {
			System.exit(0);
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
			// Easing function for moving the pause menus
			pauseMenuBottom.y += (targetYBottom - pauseMenuBottom.y) * easingSpeed * elapsed;
			pauseMenuTop.y += (targetYTop - pauseMenuTop.y) * easingSpeed * elapsed;

			if (Math.abs(pauseMenuBottom.y - targetYBottom) < 1 && Math.abs(pauseMenuTop.y - targetYTop) < 1)
			{
				// Snap to target positions
				pauseMenuBottom.y = targetYBottom;
				pauseMenuTop.y = targetYTop;

				if (!isPaused)
				{
					pauseMenuBottom.visible = false;
					pauseMenuTop.visible = false;
					isAnimating = false;
                }
            }
        }
    }

    private function togglePause():Void {
		isPaused = !isPaused; 

        if (isPaused) {
			// Show menus and start animating
			pauseMenuBottom.visible = true;
			pauseMenuTop.visible = true;
			player.canMove = false;
			// Move pause menus to target positions
			targetYBottom = FlxG.height - pauseMenuBottom.height;
			targetYTop = 0; 
        } else {
			player.canMove = true;
			// Move pause menus back off-screen
			targetYBottom = FlxG.height;
			targetYTop = -FlxG.height; 
        }
		isAnimating = true; 
    }
}
