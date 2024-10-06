import flixel.FlxSprite;

class Quest
{
	public var title:String;
	public var description:String;
	public var questImage:FlxSprite;

	public function new(title:String, description:String, imagePath:String)
	{
		this.title = title;
		this.description = description;
		questImage = new FlxSprite().loadGraphic(imagePath);
		questImage.visible = false;
		questImage.scrollFactor.set();
	}
}