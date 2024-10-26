import flixel.FlxSprite;

class Item
{
	public var name:String;
	public var description:String;
	public var imagePath:String;
	public var itemImage:FlxSprite;

	public function new(name:String, description:String, imagePath:String)
	{
		//Get and set data from call
		this.name = name;
		this.description = description;
		this.imagePath = imagePath;

		itemImage = new FlxSprite().loadGraphic(imagePath);
		itemImage.visible = true;
		itemImage.scrollFactor.set();
	}
}
