import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import lime.system.System;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
	// Allocation
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
		var cursorBitapData = Assets.getBitmapData("assets/images/cursorDot.png");
		FlxG.mouse.load(cursorBitapData);

		// Initialize NPCs
		npcs = [];
		var npc1 = new NPC(400, 650, "Hello!", "assets/images/characters/smallDuck.png");
		npcs.push(npc1);

		// Iterate through and add each npc
		for (npc in npcs)
		{
			add(npc);
		}

        // Player 
		player = new Player(npcs, 100, 600); 
        add(player);
		// Pause Menu - Starts Offscreen
		pauseMenu = new FlxSprite(FlxG.width, 0);
		pauseMenu.makeGraphic(FlxG.width / 2, FlxG.height, FlxG.color(0x88000000));
		pauseMenu.scrollFactor.set();
		pauseMenu.visible = false;
		add(pauseMenu);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
		// Toggle Fullscreen
		if (FlxG.keys.justPressed.F11)
			FlxG.fullscreen = !FlxG.fullscreen;

		// Exit Game
		if (FlxG.keys.justPressed.ESCAPE)
			System.exit(0);
		// Toggle Pause Menu
		if (FlxG.keys.justPressed.TAB)
			togglePause();
		if (!isPaused)
		{
			player.update(elapsed);
		}
	}

	private function togglePause():Void
	{
		if (isPaused)
		{
			FlxTween.to(pauseMenu, {x: FlxG.width}, 0.5, {
				onComplete: function(tween:FlxTween)
				{
					pauseMenu.visible = false;
				}
			});
		}
		else
		{
			pauseMenu.visible = false;
			FlxTween.to(pauseMenu, {x: FlxG.width / 2}, 0.5);
		}
		isPaused = !isPaused;
	}
}