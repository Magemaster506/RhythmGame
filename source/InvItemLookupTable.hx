import flixel.FlxG;

class InvItemLookupTable{

	public var testItemData:Item;

	public function new():Void
	{
		testItemData = new Item("Test name", "test description", "assets/images/missingTexture.png");
	}
}
