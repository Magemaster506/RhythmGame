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
	public var isTyping:Bool = false;
	public var isDialogueActive:Bool = false;

	// Frame management
	private var dialogueFrames:Array<String>;
	private var currentFrameIndex:Int = 0;
	private var frameChangeTimer:Float = 0; // Timer to manage frame changes
	private var frameChangeSpeed:Float = 0.04; // Time between frames

	public function new(x:Float, y:Float, dialogue:String, imagePath:String)
	{
        super(x, y);
        this.dialogue = dialogue;
		this.imagePath = imagePath;
		loadGraphic(imagePath);

		// Initialize dialogue frames
		dialogueFrames = [
			"assets/images/shared/dialogueBox/dialogueBoxAnimation0001.png",
			"assets/images/shared/dialogueBox/dialogueBoxAnimation0002.png",
			"assets/images/shared/dialogueBox/dialogueBoxAnimation0003.png",
			"assets/images/shared/dialogueBox/dialogueBoxAnimation0004.png",
			"assets/images/shared/dialogueBox/dialogueBoxAnimation0005.png",
			"assets/images/shared/dialogueBox/dialogueBoxAnimation0006.png"
		];

		// Initializing the dialogue box
		dialogueBox = new FlxSprite(100, 50);
		dialogueBox.loadGraphic(dialogueFrames[0], true, 760, 171); // Load the first frame
		dialogueBox.visible = false;
		FlxG.state.add(dialogueBox);

		// Initializing the text field for dialogue
		dialogueText = new FlxText(175, 70, 600, "");
		dialogueText.setFormat(null, 20, 0x181818, "left");
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
		
		// Update the dialogue box frame based on the timer
		if (isDialogueActive)
		{
			frameChangeTimer += elapsed;

			// Check if the current frame index is less than the length of dialogueFrames - 1
			if (currentFrameIndex < dialogueFrames.length - 1)
			{
				if (frameChangeTimer >= frameChangeSpeed)
				{
					currentFrameIndex++;
					dialogueBox.loadGraphic(dialogueFrames[currentFrameIndex], true, 760, 171);
					frameChangeTimer = 0; // Reset the timer
				}
			}
		}
		
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
		if (!isDialogueActive)
		{
			player.canMove = false;
			dialogueBox.visible = true;
			currentFrameIndex = 0; // Reset frame index to start from the first frame
			dialogueBox.loadGraphic(dialogueFrames[currentFrameIndex], true, 760, 171); // Load the first frame
			dialogueText.visible = true;
			dialogueText.text = ""; // Reset the dialogue text
			currentCharIndex = 0;
			typewriterTimer = 0;
			isTyping = true;
			isDialogueActive = true; // Set the dialogue as active
			hideInteractIndicator();
		}
	}
	public function endDialogue(player:Player):Void
	{
		player.canMove = true;
		dialogueBox.visible = false;
		dialogueText.visible = false;
		isTyping = false;
		isDialogueActive = false; // Set the dialogue as inactive
	}
}
