local followchars = true
function onCreate()

	makeLuaSprite('bg', 'koRoom', -800, -200)
	setScrollFactor('bg', 0.95, 0.95)

	makeAnimatedLuaSprite('tables', 'tables', -850, 200)
    	addAnimationByPrefix('tables','tables','TablesAll',24,false);
	setScrollFactor('tables', 0.95, 0.95)
	
	makeAnimatedLuaSprite('stage', 'koStage', -300, 900)
    	addAnimationByPrefix('stage','koStage','stage',24,true);
    	objectPlayAnimation('stage','koStage',false);
	setScrollFactor('stage', 1.0, 1.0)

	addLuaSprite('bg', false)
	addLuaSprite('tables', false)
	addLuaSprite('stage', false)
end

function onBeatHit()
	objectPlayAnimation('tables','tables' ,true);
end