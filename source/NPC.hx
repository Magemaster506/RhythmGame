import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAxes;

class NPC extends FlxSprite {
    var dialogue: String;

    public function new(x: Float, y: Float, dialogue: String) {
        super(x, y);
        this.dialogue = dialogue;
    }

    public function startDialogue(): Void {
        
    }
}
