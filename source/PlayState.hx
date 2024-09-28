import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState {
    private var player:Player;
    private var background:FlxSprite;

    override public function create():Void {
        super.create();      
        
        // Background
        background = new FlxSprite(0, 0);
        background.loadGraphic("assets/images/background.png");
        add(background);

        // Player 
        player = new Player(100, 600); 
        add(player);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}
