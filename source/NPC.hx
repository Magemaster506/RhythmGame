import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class NPC extends FlxSprite {
	var dialogue:String;
	var imagePath:String;
	var dialogueBox:FlxSprite;
	var dialogueText:FlxText;
	var interactIndicator:FlxSprite;
	var currentCharIndex:Int = 0;
	var typewriterSpeed:Float = 0.05; // Time interval between each character
	var typewriterTimer:Float = 0; // Tracks time passed between characters
	var isTyping:Bool = false;

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

		// Initializing the text field for dialogue
		dialogueText = new FlxText(195, 70, 200, "");
		dialogueText.setFormat(null, 20, 0xFFFFFF, "left");
		dialogueText.visible = false;
		FlxG.state.add(dialogueText);

		// Initializing the indicator sprite
		interactIndicator = new FlxSprite(x, y);
		interactIndicator.loadGraphic("assets/images/cursorDot.png");
		interactIndicator.visible = false;
		FlxG.state.add(interactIndicator);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Handle the typewriter effect
		if (isTyping)
		{
			typewriterTimer += elapsed;
			if (typewriterTimer >= typewriterSpeed && currentCharIndex < dialogue.length)
			{
				// Add the next character to the dialogue text
				dialogueText.text += dialogue.charAt(currentCharIndex);
				currentCharIndex++;
				typewriterTimer = 0;
			}

			// Stop typing if we've displayed the entire dialogue
			if (currentCharIndex >= dialogue.length)
			{
				isTyping = false;
			}
		}
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
		dialogueText.visible = true;
		dialogueText.text = ""; // Reset the dialogue text
		currentCharIndex = 0;
		typewriterTimer = 0;
		isTyping = true;
		hideInteractIndicator();
	}

	public function endDialogue(player:Player):Void
	{
		player.canMove = true;
		dialogueBox.visible = false;
		dialogueText.visible = false;
		isTyping = false;
	}
}
