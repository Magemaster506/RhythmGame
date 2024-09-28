import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAxes;

class Player extends FlxSprite {
    public var speed:Float = 250; 

    public function new(x:Float, y:Float) {
        super(x, y);
        loadGraphic("assets/images/bfHead.png", true, 128, 128); 
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        handleMovement();
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

        if (moveX != 0 || moveY != 0) {
            var length:Float = Math.sqrt(moveX * moveX + moveY * moveY);
            moveX /= length;
            moveY /= length;
        }

        velocity.set(moveX * speed, moveY * speed);

        flipX = (facing == LEFT);
    }
}
