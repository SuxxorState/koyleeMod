package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	private var iconCount = 2;
	private var theFrames:Array<Int> = [];
	private var thesilly:String = '';

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		thesilly = char;
		isOldIcon = (thesilly.endsWith('-old'));
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 12, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		thesilly = char;
		if(isOldIcon = !isOldIcon && (Paths.fileExists('images/icons/' + char + '-old.png', IMAGE) || Paths.fileExists('images/icons/icon-' + char + '-old.png', IMAGE)))
			thesilly = char + "-old";
		else if (char.endsWith('-old') && (Paths.fileExists('images/icons/' + char + '.png', IMAGE) || Paths.fileExists('images/icons/icon-' + char + '.png', IMAGE)))
			thesilly = char.replace('-old', '');
		changeIcon(thesilly);
	}

	private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			iconCount = Math.round(width / 150);
			iconCount *= Math.round(height / 150);
			loadGraphic(file, true, Math.floor(width / Math.round(width / 150)), Math.floor(height / Math.round(height / 150))); //Then load it fr
			iconOffsets = [(width - 150) / 2, (height - 150) / 2];
			updateHitbox();

			for (i in 0...iconCount) theFrames.push(i);
			animation.add(char, theFrames, 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String {
		return char;
	}
}
