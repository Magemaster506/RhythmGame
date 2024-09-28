import flixel.FlxG;
import flixel.FlxSprite;

class NPC extends FlxSprite {
	var dialogue:String;
	var imagePath:String;
	var dialogueBox:FlxSprite;
	var interactIndicator:FlxSprite;

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
		// Initializing the indicator sprite
		interactIndicator = new FlxSprite(x, y);
		interactIndicator.loadGraphic("assets/images/cursorDot.png");
		interactIndicator.visible = false;
		FlxG.state.add(interactIndicator);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	public function showInteractIndicator():Void
	{
		interactIndicator.visible = true;
		interactIndicator.setPosition(x + width / 2 - 9, y - interactIndicator.height - 5);
	}

	public function hideInteractIndicator():Void
	{
		interactIndicator.visible = false;
	}

	public function startDialogue(player:Player):Void
	{
		player.canMove = false;
		dialogueBox.visible = true;
		hideInteractIndicator();
		// Display text ...
	}

	public function endDialogue(player:Player):Void
	{
		player.canMove = true;
		dialogueBox.visible = false;
	}
}