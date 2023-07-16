package;

#if desktop
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;

using StringTools;
typedef TitleData =
{

	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;
	public static var musicSwitch:Bool = true;

	var mustUpdate:Bool = false;

	var titleJSON:TitleData;
	var logotween1:FlxTween;
	var logotween2:FlxTween;

	public static var updateVersion:String = '';

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		//trace(path, FileSystem.exists(path));

		/*#if (polymod && !html5)
		if (sys.FileSystem.exists('mods/')) {
			var folders:Array<String> = [];
			for (file in sys.FileSystem.readDirectory('mods/')) {
				var path = haxe.io.Path.join(['mods/', file]);
				if (sys.FileSystem.isDirectory(path)) {
					folders.push(file);
				}
			}
			if(folders.length > 0) {
				polymod.Polymod.init({modRoot: "mods", dirs: folders});
			}
		}
		#end*/

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();
		super.create();

		FlxG.save.bind('koyleeMod', 'SuxxorState');

		ClientPrefs.loadPrefs();

		Highscore.load();

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		} else {
			startIntro();
		}
		#end
	}

	var bg:FlxSprite;
	var logoBl:FlxSprite;
	var logo:FlxSprite;

	function startIntro()
	{
		if((FlxG.sound.music == null && !initialized) || !musicSwitch) {
			FlxG.sound.playMusic(Paths.music('title'), 0.7);
			musicSwitch = true;
		}
		if (!initialized)
		{
			/*var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;*/
		}

		persistentUpdate = true;

		bg = new FlxSprite().loadGraphic(Paths.image('titleback'));
		bg.antialiasing = true;
		bg.setGraphicSize(Std.int(bg.width * 0.6));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		logoBl = new FlxSprite().loadGraphic(Paths.image('logo'));
		logoBl.screenCenter();
		logoBl.color = FlxColor.BLACK;
		add(logoBl);
		logo = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		add(logo);

		if (initialized) {
		logoBl.y -= 250;
		logo.y -= 250;
		logoBl.alpha = 0;
		logo.alpha = 0;
		}

		if (initialized) logotween1 = FlxTween.tween(logoBl, {y: logoBl.y + 300, alpha: 1}, 0.5, {ease: FlxEase.quadInOut, startDelay: 0.1});
		else logotween1 = FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});
		if (initialized) logotween2 = FlxTween.tween(logo, {y: logoBl.y + 300, alpha: 1}, 0.5, {ease: FlxEase.quadInOut});
		else logotween2 = FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized) {
			new FlxTimer().start(0.6, function(tmr:FlxTimer) {
				logotween1 = FlxTween.tween(logoBl, {y: logoBl.y - 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});
				logotween2 = FlxTween.tween(logo, {y: logoBl.y - 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
			});
		}

		if (!initialized) initialized = true;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (initialized && !transitioning)
		{			
			if(pressedEnter)
			{
				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				//FlxG.sound.music.stop();
				FlxG.sound.play(Paths.sound('confirmMenu'));
				logotween1.cancel();
				logotween2.cancel();
				logotween1 = FlxTween.tween(logoBl, {y: -logoBl.height - 50}, 0.6, {ease: FlxEase.quadInOut, startDelay: 0.05});
				logotween2 = FlxTween.tween(logo, {y: -logoBl.height - 50}, 0.6, {ease: FlxEase.quadInOut});
				transitioning = true;

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					MusicBeatState.switchState(new MainMenuState());
					closedState = true;
				});
			}
		}
		super.update(elapsed);
	}
	public static var closedState:Bool = false;

	var increaseVolume:Bool = false;
}
