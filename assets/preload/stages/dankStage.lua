local followchars = true
local bopdir = false

function onCreate()

	makeLuaSprite('bg', 'koRoom', -800, -200)
	setScrollFactor('bg', 0.95, 0.95)

	makeAnimatedLuaSprite('tables', 'tables', -850, 200)
    	addAnimationByPrefix('tables','tables','TablesAll',24,false);
	setScrollFactor('tables', 0.95, 0.95)
	
	makeLuaSprite('stage', 'koStageOff', -300, 900)
	setScrollFactor('stage', 1.0, 1.0)
	
	makeLuaSprite('dark', 'koDark', -1300, -800)
	setScrollFactor('dark', 1.0, 1.0)
	    setObjectOrder('dark', 6);

	addLuaSprite('bg', false)
	addLuaSprite('tables', false)
	addLuaSprite('stage', false)
	addLuaSprite('dark', false)
end

function onBeatHit()
	objectPlayAnimation('tables','tables' ,true);
end