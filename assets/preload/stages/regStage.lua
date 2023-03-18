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

function onUpdate()
     if followchars == true then
        if mustHitSection == false then
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',490,800)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',510,800)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',500,790)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',500,810)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',500,800)
            end
        else

            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',830,800)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',870,800)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',850,780)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',850,820)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',850,800)
            end
        end
	else
        triggerEvent('Camera Follow Pos','','')
	end
end