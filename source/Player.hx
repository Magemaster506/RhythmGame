import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite {
    public var speed:Float = 125;
    var interactionRange:Float = 100;
    public var npcs:Array<NPC>; 
    public var canMove:Bool = true;
    private var dialogueCooldown:Bool = false;
    private var dialogueCooldownTime:Float = 1.5; // 0.5 seconds cooldown
    public var lastDialogueToggleTime:Float = 0; // Timer for last toggle

    public function new(npcs:Array<NPC>, x:Float, y:Float)
    {
        super(x, y);
        this.npcs = npcs;
        loadGraphic("assets/images/characters/bfHead.png", true, 128, 128); 
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        lastDialogueToggleTime += elapsed; // Update the timer
        handleMovement();
        checkNPCInteraction();
    }

    private function handleMovement():Void {
        var moveX:Float = 0;
        var moveY:Float = 0;

        if (FlxG.keys.pressed.A) {
            moveX = -1;
            facing = LEFT; 
        } else if (FlxG.keys.pressed.D) {
            moveX = 1;
            facing = RIGHT;
        }
        if (FlxG.keys.pressed.W) {
            moveY = -1;
        } else if (FlxG.keys.pressed.S) {
            moveY = 1;
        }

        if (canMove)
        {
            if (moveX != 0 || moveY != 0)
            {
                var length:Float = Math.sqrt(moveX * moveX + moveY * moveY);
                moveX /= length;
                moveY /= length;
            }
            velocity.set(moveX * speed, moveY * speed);
            flipX = (facing == LEFT);
        }
        else
        {
            velocity.set(0, 0);
        }
    }

	private function checkNPCInteraction():Void
		{
			for (npc in npcs)
			{
				var dx:Float = this.x - npc.x;
				var dy:Float = this.y - npc.y;
				var distance:Float = Math.sqrt(dx * dx + dy * dy);
		
				if (distance < interactionRange)
				{
					npc.showInteractIndicator();
		
					// Use SPACE to toggle between starting and ending dialogue
					if (FlxG.keys.justPressed.SPACE && !dialogueCooldown && lastDialogueToggleTime > dialogueCooldownTime)
					{
						if (npc.isDialogueActive)
						{
                            dialogueCooldown = true;
                            lastDialogueToggleTime = 0; // Reset the timer
							// Check if we're at the last line before ending dialogue
							if (npc.currentLineIndex < npc.dialogue.length)
							{
								// If not at the last line, just go to the next line
								npc.nextLine();
                                dialogueCooldown = true;
								lastDialogueToggleTime = 0; // Reset the timer
							}
							else
							{
								// If at the last line, end dialogue
								npc.endDialogue(this);
		
								// Activate the cooldown here, only after ending dialogue
								dialogueCooldown = true;
								lastDialogueToggleTime = 0; // Reset the timer
							}
						}
						else
						{
							npc.startDialogue(this);
                            dialogueCooldown = true;
                            lastDialogueToggleTime = 0; // Reset the timer
						}
					}
				}
				else
				{
					npc.hideInteractIndicator();
				}
			}
		
			// Reset cooldown when SPACE is released
			if (FlxG.keys.justReleased.SPACE)
			{
				dialogueCooldown = false;
			}
		}
		
}
