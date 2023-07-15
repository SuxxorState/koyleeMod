package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.graphics.FlxGraphic;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import WeekData;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'stage_fright',
		'freeplay',
		'options',
		'credits'
	];

	var debugKeys:Array<FlxKey>;
	var stagefright:WeekData;
	var difficultySelectors:FlxTypedGroup<FlxSprite>;
	var sprDifficulty:FlxSprite;
	var difficultyBG:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;
	var koyleeChr:MenuCharacter;
	var boyfriendChr:MenuCharacter;

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();
		WeekData.reloadWeekFiles(false);

		stagefright = WeekData.weeksLoaded.get(WeekData.weeksList[0]);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('titleback'));
		bg.scrollFactor.set();
		bg.setGraphicSize(Std.int(bg.width * 0.6));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		
		koyleeChr = new MenuCharacter(-250, 'ko');
		koyleeChr.setGraphicSize(Std.int(koyleeChr.width * 2));
		koyleeChr.updateHitbox();
		koyleeChr.color = FlxColor.BLACK;
		koyleeChr.y += 200;
		koyleeChr.alpha = 0;
		add(koyleeChr);

		boyfriendChr = new MenuCharacter(930, 'bf');
		boyfriendChr.setGraphicSize(Std.int(boyfriendChr.width * 1.75));
		boyfriendChr.updateHitbox();
		boyfriendChr.color = FlxColor.BLACK;
		boyfriendChr.y += 275;
		boyfriendChr.alpha = 0;
		add(boyfriendChr);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + (i == 0 ? 38 : 148));
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			menuItem.y += 1000;
			FlxTween.tween(menuItem, {y: (i * 140) + (i == 0 ? 38 : 148)}, 0.5, {ease: FlxEase.quadOut, startDelay: 0.25 * i});
			menuItem.ID = i;
		}

		difficultySelectors = new FlxTypedGroup<FlxSprite>();
		add(difficultySelectors);

		leftArrow = new FlxSprite(menuItems.members[0].x + menuItems.members[0].width + 10, 730);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		leftArrow.alpha = 0;

		difficultyBG = new FlxSprite(-10, leftArrow.y - 5).makeGraphic(FlxG.width + 20, Std.int(leftArrow.height + 20), 0x99000000);
		difficultyBG.alpha = 0;
		difficultySelectors.add(difficultyBG);
		difficultySelectors.add(leftArrow);

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		sprDifficulty = new FlxSprite(0, leftArrow.y);
		sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
		sprDifficulty.alpha = 0;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 376, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow.alpha = 0;
		difficultySelectors.add(rightArrow);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();
		changeDifficulty();
		
		FlxTween.tween(koyleeChr, {x: -150, alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(boyfriendChr, {x: 830, alpha: 1}, 0.5, {ease: FlxEase.quadOut});

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.pvocals != null) FreeplayState.pvocals.volume += 0.5 * elapsed;
			if(FreeplayState.ovocals != null) FreeplayState.ovocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.UI_RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.UI_LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');

			if (controls.UI_RIGHT_P && curSelected == 0)
				changeDifficulty(1);
			else if (controls.UI_LEFT_P && curSelected == 0)
				changeDifficulty(-1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxTween.tween(koyleeChr, {x: -250, alpha: 0}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(boyfriendChr, {x: 930, alpha: 0}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(difficultyBG, {y: 725, alpha: 0}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(leftArrow, {y: 730, alpha: 0}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(sprDifficulty, {y: 740, alpha: 0}, 0.5, {ease: FlxEase.quadOut});
				FlxTween.tween(rightArrow, {y: 730, alpha: 0}, 0.5, {ease: FlxEase.quadOut});
				menuItems.forEach(function(spr:FlxSprite){
					FlxTween.tween(spr, {y: spr.y + 250, alpha: 0}, 0.5, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween){spr.kill();}});
				});
				new FlxTimer().start(1, function(tmr:FlxTimer) {
					MusicBeatState.switchState(new TitleState());
				});
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				if (curSelected == 0) FlxG.sound.music.stop();
				FlxG.sound.play(curSelected == 0 ? Paths.music('titleShoot') : Paths.sound('confirmMenu'));
				boyfriendChr.animation.play('confirm', true);

				//if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'stage_fright':
									var songArray:Array<String> = [];
									var leWeek:Array<Dynamic> = stagefright.songs;
									for (i in 0...leWeek.length) {
										songArray.push(leWeek[i][0]);
									}
							
									PlayState.storyPlaylist = songArray;
									PlayState.isStoryMode = true;
							
									var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
									if(diffic == null) diffic = '';
							
									PlayState.storyDifficulty = curDifficulty;
							
									PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
									PlayState.campaignScore = 0;
									PlayState.campaignMisses = 0;
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										LoadingState.loadAndSwitchState(new PlayState(), true);
										FreeplayState.destroyFreeplayVocals();
									});
								case 'freeplay':
									MusicBeatState.switchState(new FreeplayState());
								case 'credits':
									MusicBeatState.switchState(new CreditsState());
								case 'options':
									LoadingState.loadAndSwitchState(new options.OptionsState());
							}
						});
					}
				});
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				spr.centerOffsets();
			}
		});

		FlxTween.tween(difficultyBG, {y: (curSelected == 0 ? 625 : 725), alpha: (curSelected == 0 ? 1 : 0)}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(leftArrow, {y: (curSelected == 0 ? 630 : 730), alpha: (curSelected == 0 ? 1 : 0)}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(sprDifficulty, {y: (curSelected == 0 ? 640 : 740), alpha: (curSelected == 0 ? 1 : 0)}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(rightArrow, {y: (curSelected == 0 ? 630 : 730), alpha: (curSelected == 0 ? 1 : 0)}, 0.5, {ease: FlxEase.quadOut});
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.defaultDifficulties.length-1;
		if (curDifficulty >= CoolUtil.defaultDifficulties.length)
			curDifficulty = 0;

		var diff:String = CoolUtil.defaultDifficulties[curDifficulty];
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));
		//trace(Paths.currentModDirectory + ', menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = (FlxG.width - sprDifficulty.width) / 2;
			leftArrow.x = sprDifficulty.x - (leftArrow.width + 20);
			rightArrow.x = sprDifficulty.x + sprDifficulty.width + 20;
			sprDifficulty.alpha = 0;
			sprDifficulty.y = leftArrow.y - 15;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: leftArrow.y + 10, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;
	}
}
