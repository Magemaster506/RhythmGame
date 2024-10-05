import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.text.FlxText;

class NPC extends FlxSprite {
	public var dialogue:Array<String>; // Array to store multiple lines of dialogue
	var imagePath:String;
	var dialogueBox:FlxSprite;
	var dialogueText:FlxText;
	var interactIndicator:FlxSprite;
	public var currentLineIndex:Int = 0; // Track the current dialogue line

	var currentCharIndex:Int = 0; // Track character index for typing effect
	var typewriterSpeed:Float = 0.05; // Time interval between each character
	var typewriterTimer:Float = 0; // Timer for typewriter effect

	public var isTyping:Bool = false; // Check if currently typing
	public var isDialogueActive:Bool = false; // Check if dialogue is active

	private var player:Player; // Reference to the Player object

	// Frame management
	private var dialogueFrames:Array<String>;
	private var interactionMarkerFrames:Array<String>;

	// Animation frame indexes and timers
	private var dialogueFrameIndex:Int = 0;
	private var interactionFrameIndex:Int = 0;
	private var dialogueFrameTimer:Float = 0;
	private var interactionFrameTimer:Float = 0;
	private var frameChangeSpeed:Float = 0.04; // Time between frames

	public function new(x:Float, y:Float, dialogue:Array<String>, imagePath:String)
	{
		super(x, y);
		this.dialogue = dialogue; // Assign dialogue array
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

		// Initialize dialogue box
		dialogueBox = new FlxSprite(100, 50);
		dialogueBox.loadGraphic(dialogueFrames[0], true, 760, 171); // Load the first frame
		dialogueBox.visible = false; // Start hidden
		FlxG.state.add(dialogueBox);

		// Initialize the text field for dialogue
		dialogueText = new FlxText(175, 70, 600, "");
		dialogueText.setFormat(null, 20, 0x181818, "left");
		dialogueText.visible = false; // Start hidden
		FlxG.state.add(dialogueText);

		// Initialize the indicator sprite
		interactionMarkerFrames = [
			"assets/images/characters/ui/interactionMarker0001.png",
			"assets/images/characters/ui/interactionMarker0002.png",
			"assets/images/characters/ui/interactionMarker0003.png",
			"assets/images/characters/ui/interactionMarker0004.png",
			"assets/images/characters/ui/interactionMarker0005.png",
			"assets/images/characters/ui/interactionMarker0006.png",
			"assets/images/characters/ui/interactionMarker0007.png",
			"assets/images/characters/ui/interactionMarker0008.png",
			"assets/images/characters/ui/interactionMarker0009.png"
		];
		// Initialize interaction marker
		interactIndicator = new FlxSprite(x, y);
		interactIndicator.loadGraphic(interactionMarkerFrames[0], true, 17, 37);
		interactIndicator.visible = false; // Start hidden
		FlxG.state.add(interactIndicator);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Update the dialogue box frame based on its timer
		if (isDialogueActive)
		{
			dialogueFrameTimer += elapsed;

			// Change dialogue box frame
			if (dialogueFrameIndex < dialogueFrames.length - 1 && dialogueFrameTimer >= frameChangeSpeed)
			{
				dialogueFrameIndex++;
				dialogueBox.loadGraphic(dialogueFrames[dialogueFrameIndex], true, 760, 171);
				dialogueFrameTimer = 0; // Reset the timer
			}
		}

		// Update interaction marker animation
		interactionFrameTimer += elapsed;
		if (interactionFrameTimer >= frameChangeSpeed)
		{
			interactionFrameIndex = (interactionFrameIndex + 1) % interactionMarkerFrames.length;
			interactIndicator.loadGraphic(interactionMarkerFrames[interactionFrameIndex], true, 17, 37);
			interactionFrameTimer = 0; // Reset the timer
		}

		// Handle the typewriter effect
		if (isTyping)
		{
			typewriterTimer += elapsed;
			if (typewriterTimer >= typewriterSpeed && currentCharIndex < dialogue[currentLineIndex].length)
			{
				// Add the next character to the dialogue text
				dialogueText.text += dialogue[currentLineIndex].charAt(currentCharIndex);
				currentCharIndex++;
				typewriterTimer = 0; // Reset the timer
			}

			// Stop typing if the entire line has been displayed
			if (currentCharIndex >= dialogue[currentLineIndex].length)
			{
				isTyping = false;
			}
		}

		// Check for SPACE key to cycle through dialogue
		if (isDialogueActive)
		{
			if (FlxG.keys.justPressed.SPACE) // Change from pressed to justPressed
			{
				if (!isTyping) // Only cycle if not typing
				{
					if (currentLineIndex < dialogue.length - 1)
					{
						currentLineIndex++; // Move to the next line
						currentCharIndex = 0; // Reset character index for the new line
						dialogueText.text = ""; // Reset text to start typing new line
						isTyping = true; // Start typing effect
						player.lastDialogueToggleTime = 0;
					}
					else if (currentLineIndex == dialogue.length - 1)
					{
						// If on the last line and SPACE is pressed, end dialogue
						player.lastDialogueToggleTime = 0; // Reset the timer
						endDialogue(player);
					}
				}
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
			this.player = player; // Store the player reference
			player.canMove = false; // Disable player movement during dialogue
			dialogueBox.visible = true; // Show the dialogue box
			dialogueFrameIndex = 0; // Reset frame index for dialogue box
			dialogueBox.loadGraphic(dialogueFrames[dialogueFrameIndex], true, 760, 171); // Load the first frame
			dialogueText.visible = true; // Show dialogue text
			dialogueText.text = ""; // Reset the dialogue text
			currentLineIndex = 0; // Reset current line index
			currentCharIndex = 0; // Reset character index
			typewriterTimer = 0; // Reset timer for typewriter effect
			isTyping = true; // Set typing to true
			isDialogueActive = true; // Set dialogue as active
			hideInteractIndicator(); // Hide interaction indicator
		}
	}

	public function endDialogue(player:Player):Void
	{
		player.canMove = true; // Enable player movement
		dialogueBox.visible = false; // Hide the dialogue box
		dialogueText.visible = false; // Hide dialogue text
		isTyping = false; // Set typing to false
		isDialogueActive = false; // Set dialogue as inactive
	}
	public function nextLine():Void
	{
		if (currentLineIndex < dialogue.length - 1)
		{
			currentLineIndex++; // Move to the next line
			currentCharIndex = 0; // Reset character index for the new line
			dialogueText.text = ""; // Reset text to start typing new line
			isTyping = true; // Start typing effect
		}
	}
		
		
}
