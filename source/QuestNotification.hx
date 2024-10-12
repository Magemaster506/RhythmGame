import flixel.FlxG;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSprite;

class QuestNotification extends FlxSprite
{
    private var animFrames:Array<String>; // Array of image paths for the opening animation frames
    private var idleFrames:Array<String>; // Array of image paths for the idle animation frames
    private var currentFrameIndex:Int = 0; // Index to track the current frame
    private var animationSpeed:Float = 0.03; // Speed of the opening animation (in seconds per frame)
    private var idleAnimationSpeed:Float = 0.055; // Speed of the idle animation (in seconds per frame)
    private var timer:Float = 0; // Timer to keep track of frame switching
    private var isIdle:Bool = false; // Flag to check if idle animation is playing
    private var idleDuration:Float = 3; // Duration for how long the idle animation should loop
    private var idleTimer:Float = 0; // Timer for idle animation duration

    public function new(x:Float, y:Float, frames:Array<String>, idleFrames:Array<String>)
    {
        super(x, y);
        this.animFrames = frames; // Store the opening frames
        this.idleFrames = idleFrames; // Store the idle frames
        this.loadGraphic(animFrames[0]); // Load the first frame initially
        this.scrollFactor.set(); // Fix position to the camera (no scrolling)
        this.visible = false; // Initially hidden until a quest is added
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (this.visible)
        {
            timer += elapsed;
            
			if (isIdle)
            {
                // Update idle animation with idle animation speed
                if (timer >= idleAnimationSpeed)
                {
                    currentFrameIndex = (currentFrameIndex + 1) % idleFrames.length;
                    this.loadGraphic(idleFrames[currentFrameIndex]);
                    timer = 0;
                }

                // Track the idle animation time
                idleTimer += elapsed;
                if (idleTimer >= idleDuration)
                {
                    stopAnimation(); // Stop after the set idle duration
                }
            }
            else
            {
                // Update opening animation with the opening animation speed
                if (timer >= animationSpeed)
                {
                    currentFrameIndex = (currentFrameIndex + 1) % animFrames.length;
                    this.loadGraphic(animFrames[currentFrameIndex]);
                    timer = 0;

                    // If opening animation is done, switch to idle animation
                    if (currentFrameIndex == animFrames.length - 1)
                    {
                        startIdleAnimation();
                    }
                }
            }
        }
    }

    public function playAnimation():Void
    {
        this.visible = true; // Make the notification visible when playing the animation
        currentFrameIndex = 0; // Start from the first frame
        this.loadGraphic(animFrames[currentFrameIndex]);
        isIdle = false; // Start with opening animation
        idleTimer = 0; // Reset the idle timer
    }

    public function stopAnimation():Void
    {
        this.visible = false; // Hide the notification after the animation
        currentFrameIndex = 0; // Reset the frame index
    }

    private function startIdleAnimation():Void
    {
        isIdle = true; // Switch to idle animation
        currentFrameIndex = 0; // Reset the frame index for the idle animation
        this.loadGraphic(idleFrames[currentFrameIndex]); // Load the first idle frame
        timer = 0; // Reset the timer
    }
}
