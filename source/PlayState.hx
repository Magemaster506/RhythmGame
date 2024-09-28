import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import lime.system.System;
import openfl.Assets;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState {
	// Allocation
    private var player:Player;
    private var background:FlxSprite;
	private var npcs:Array<NPC>;

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
		var npc1 = new NPC(400, 650, "Hello!", "assets/images/smallDuck.png");
		npcs.push(npc1);

		// Iterate through and add each npc
		for (npc in npcs)
		{
			add(npc);
		}


        // Player 
		player = new Player(npcs, 100, 600); 
        add(player);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
		// Toggle Fullscreen
		if (FlxG.keys.justPressed.F11)
			FlxG.fullscreen = !FlxG.fullscreen;

		// Exit Game
		if (FlxG.keys.justPressed.ESCAPE)
			System.exit(0);
    }
}