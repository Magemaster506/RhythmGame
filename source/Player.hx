import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite {
    public var speed:Float = 250; 
	public var npcs:Array<NPC>; 
	public var canMove:Bool = true;

	public function new(npcs:Array<NPC>, x:Float, y:Float)
	{
        super(x, y);
		this.npcs = npcs; 
        loadGraphic("assets/images/bfHead.png", true, 128, 128); 
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
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
		}
		else
		{
			velocity.set(0, 0);
		}

		flipX = (facing == LEFT);
	}


	private function checkNPCInteraction():Void
	{
		var interactionRange:Float = 50;
		for (npc in npcs)
		{
			var dx:Float = this.x - npc.x;
			var dy:Float = this.y - npc.y;
			var distance:Float = Math.sqrt(dx * dx + dy * dy);

			if (distance < interactionRange)
			{
				if (FlxG.keys.justPressed.SPACE)
				{
					npc.startDialogue(this);
				}
			}
		}
    }
}