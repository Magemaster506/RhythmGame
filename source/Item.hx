import flixel.FlxSprite;

class Item
{
	public var name:String;
	public var description:String;
	public var imagePath:String;
	public var itemImage:FlxSprite;

	public function new(name:String, description:String, imagePath:String)
	{
		//Get and set data from where function is called
		this.name = name;
		this.description = description;
		this.imagePath = imagePath;
//built in ligatures are cool asf
	// In future I want to load the images from a for loop ->
	   // so that they are not tied to the item obj coming from this class.
//		itemImage = new FlxSprite().loadGraphic(imagePath);
//		itemImage.visible = true;
//		itemImage.scrollFactor.set();
	}
}
