import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAxes;

class NPC extends FlxSprite {
    var dialogue: String;
	var imagePath:String;

	public function new(x:Float, y:Float, dialogue:String, imagePath:String)
	{
        super(x, y);
        this.dialogue = dialogue;
		this.imagePath = imagePath;
		loadGraphic(imagePath);
    }

    public function startDialogue(): Void {
        
    }
}