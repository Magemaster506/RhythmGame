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

        // Pause Menu (offscreen initially)
        pauseMenu = new FlxSprite(0, -FlxG.height); // Start offscreen at the top left
        pauseMenu.makeGraphic(Std.int(FlxG.width / 2 - 150), FlxG.height, 0xBA000000); // Semi-transparent black
        pauseMenu.scrollFactor.set(); // No scrolling
        pauseMenu.visible = false; // Hidden initially
        add(pauseMenu);
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

        // Only update player movement if not paused
        if (!isPaused) {
            player.update(elapsed);
        }

        // Move the pause menu if it's visible
        if (pauseMenu.visible) {
            if (isPaused) {
                // Animate the pause menu downwards
                if (pauseMenu.y < 0) {
                    pauseMenu.y += 2000 * elapsed; // Speed of the animation
                    if (pauseMenu.y >= 0) {
                        pauseMenu.y = 0; // Snap to target position
                    }
                }
            } else {
                // Animate the pause menu upwards
                if (pauseMenu.y > -FlxG.height) {
                    pauseMenu.y -= 3000 * elapsed; // Speed of the animation
                    if (pauseMenu.y <= -FlxG.height) {
                        pauseMenu.y = -FlxG.height; // Snap to target position
                        pauseMenu.visible = false; // Hide when offscreen
                    }
                }
            }
        }
    }

    private function togglePause():Void {
        isPaused = !isPaused; // Toggle paused state

        if (isPaused) {
            pauseMenu.visible = true; // Show menu immediately
			player.canMove = false;
        } else {
			player.canMove = true;
            // Unpause: Slide the pause menu offscreen upwards
            // This will be handled in the update function
        }
    }
}
