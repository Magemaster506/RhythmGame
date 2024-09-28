import flixel.FlxG;
import flixel.FlxSprite;

class NPC extends FlxSprite {
	var dialogue:String;
	var imagePath:String;
	var dialogueBox:FlxSprite;

	public function new(x:Float, y:Float, dialogue:String, imagePath:String)
	{
        super(x, y);
        this.dialogue = dialogue;
		this.imagePath = imagePath;
		loadGraphic(imagePath);
		// Initializing the dialogue box
		dialogueBox = new FlxSprite(185, 60);
		dialogueBox.loadGraphic("assets/images/dialogueBox.png");
		dialogueBox.visible = false;
		FlxG.state.add(dialogueBox);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function startDialogue(player:Player):Void
	{
		player.canMove = false;
		dialogueBox.visible = true;
		// Display text ...
	}

	public function endDialogue(player:Player):Void
	{
		player.canMove = true;
		dialogueBox.visible = false;
	}
}