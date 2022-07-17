local followchars = true

function onCreate()

	makeLuaSprite('bg', 'bgBONUS2', -1000, -200)
	setScrollFactor('bg', 1, 1)
	addLuaSprite('bg', false)
end

function onUpdate()
    if followchars == true then
	if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
        if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
            triggerEvent('Camera Follow Pos',90,750)
        end
        if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
            triggerEvent('Camera Follow Pos',110,750)
        end
        if getProperty('dad.animation.curAnim.name') == 'singUP' then
            triggerEvent('Camera Follow Pos',100,740)
        end
        if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
            triggerEvent('Camera Follow Pos',100,760)
        end
        if getProperty('dad.animation.curAnim.name') == 'idle' then
            triggerEvent('Camera Follow Pos',100,750)
        end	
	else	
        if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
            triggerEvent('Camera Follow Pos',80,750)
        end
        if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
            triggerEvent('Camera Follow Pos',120,750)
        end
        if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
            triggerEvent('Camera Follow Pos',100,730)
        end
        if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
            triggerEvent('Camera Follow Pos',100,770)
        end
	end
	else
        triggerEvent('Camera Follow Pos','','')
	end
end