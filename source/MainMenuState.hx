import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import lime.system.System;

class MainMenuState extends FlxState {
    private var options:Array<String>;
    private var selectedIndex:Int = 0;
    private var optionTexts:Array<FlxText>; // Change to FlxText

    override public function create():Void {
        super.create();

        // Define menu options
        options = ["Play", "Options", "Credits", "Exit"];
        optionTexts = [];

        // Create menu option display using FlxText
        for (i in 0...options.length) {
            var optionText = new FlxText(FlxG.width / 2 - 200, 100 + i * 100, 400, options[i]);
            optionText.setFormat(null, 50, 0xFFFFFF, "center"); // Set font size and color
            optionTexts.push(optionText);
            add(optionText);
        }

        updateMenuText();
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Navigate through menu options
        if (FlxG.keys.justPressed.W) {
            selectedIndex = (selectedIndex - 1 + options.length) % options.length;
            updateMenuText();
        }
        if (FlxG.keys.justPressed.S) {
            selectedIndex = (selectedIndex + 1) % options.length;
            updateMenuText();
        }
        if (FlxG.keys.justPressed.ENTER) {
            selectOption();
        }
    }

    private function updateMenuText():Void {
        for (i in 0...options.length) {
            optionTexts[i].color = (i == selectedIndex) ? 0xFFFF00 : 0xFFFFFF; // Highlight selected option
        }
    }

    private function selectOption():Void {
        switch (selectedIndex) {
            case 0: // Play
                FlxG.switchState(new PlayState());
            case 1: // Options
                // Handle options
            case 2: // Credits
                // Handle credits
            case 3: // Exit
                System.exit(0);
        }
    }
}
