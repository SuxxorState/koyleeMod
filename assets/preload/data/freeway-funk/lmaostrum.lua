

function onUpdatePost()
	songPos = getSongPosition()
	local currentBeat = (songPos/100)/(curBpm/70)

	--doTweenAngle('ooooWtf?', 'camHUD', -2 * 2 * math.sin((currentBeat+1)+100), 0.01)

	 -- direction fix
	 noteCount = getProperty('notes.length')
	 for i = 0, noteCount-1 do
		 noteData = getPropertyFromGroup('notes', i, 'noteData')
		 if getPropertyFromGroup('notes', i, 'isSustainNote') then
			 if (getPropertyFromGroup('notes', i, 'mustPress')) then
				 setPropertyFromGroup('notes', i, 'angle', getPropertyFromGroup('playerStrums', noteData, 'direction') - 90)
			 else			 
				 setPropertyFromGroup('notes', i, 'angle', getPropertyFromGroup('opponentStrums', noteData, 'direction') - 90)
			 end    
		 else
			 if (noteData >= 4) then
				 setPropertyFromGroup('notes', i, 'angle', getPropertyFromGroup('playerStrums', noteData, 'angle'))
			 else
				 setPropertyFromGroup('notes', i, 'angle', getPropertyFromGroup('opponentStrums', noteData, 'angle'))
			 end    
		 end
	 end

	if curBeat > 188 and curBeat < 252 then	
		songPos = getSongPosition()
		local currentBeat = (songPos/1000)*(bpm/60)
		--for i1 = 0, 7, 1 do
		--	setPropertyFromGroup('strumLineNotes',i1,'direction',90+math.sin((currentBeat/5)*math.pi)*20)
		--end
		setPropertyFromGroup('strumLineNotes',0,'angle',-45-math.sin((currentBeat/4)*math.pi)*45)
		setPropertyFromGroup('strumLineNotes',1,'angle',45-math.sin((currentBeat/4)*math.pi)*45)
		setPropertyFromGroup('strumLineNotes',2,'angle',45+math.sin((currentBeat/4)*math.pi)*45)
		setPropertyFromGroup('strumLineNotes',3,'angle',-45+math.sin((currentBeat/4)*math.pi)*45)
		setPropertyFromGroup('strumLineNotes',4,'angle',-45-math.sin((currentBeat/4)*math.pi)*45)
		setPropertyFromGroup('strumLineNotes',5,'angle',45-math.sin((currentBeat/4)*math.pi)*45)
		setPropertyFromGroup('strumLineNotes',6,'angle',45+math.sin((currentBeat/4)*math.pi)*45)
		setPropertyFromGroup('strumLineNotes',7,'angle',-45+math.sin((currentBeat/4)*math.pi)*45)
			--setPropertyFromGroup('strumLineNotes',i,'x',200+ 120*i + math.sin((currentBeat/4)*math.pi)*160)
	end

	if curBeat > 159  and curBeat < 189 then 
		local RANGE = 5
		local currentBeat = (getSongPosition() / 1000)*(bpm/60) * (getProperty('songSpeed') * 0.4)
		for i = 0, getProperty('playerStrums.length') -1 do
			setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] + RANGE * math.sin((currentBeat + i*0.25) * math.pi));
			setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + RANGE * math.cos((currentBeat + i*0.25) * math.pi));
		end
	end
	
	if (curBeat == 188) then
		for i=0,7 do
		   noteTweenAngle('speen'..i, i, 3600, 0.25,'quadinout')	
		end	
		noteTweenX('themergeoppX0', 0, defaultOpponentStrumX1, 0.25,'quadinout')
		noteTweenX('themergeoppX3', 3, defaultOpponentStrumX2, 0.25,'quadinout')
		noteTweenX('themergeplrX0', 4, defaultPlayerStrumX1, 0.25,'quadinout')
		noteTweenX('themergeplrX3', 7, defaultPlayerStrumX2, 0.25,'quadinout')
	end

	if (curBeat == 252) then
		for i=0,7 do
		   noteTweenAngle('unspeen'..i, i, 3600, 0.25,'quadinout')	
		end
		noteTweenX('theseperationoppX0', 0, defaultOpponentStrumX0, 0.25,'quadinout')
		noteTweenX('theseperationoppX3', 3, defaultOpponentStrumX3, 0.25,'quadinout')
		noteTweenX('theseperationplrX0', 4, defaultPlayerStrumX0, 0.25,'quadinout')
		noteTweenX('theseperationplrX3', 7, defaultPlayerStrumX3, 0.25,'quadinout')
	end
	
	if (curBeat == 96) and not downscroll then --Notes Come From The Left
		
		--Player Strum Movement
		for i=0,3 do
			noteTweenX('defaultPlayerStrumX'..i, i + 4, defaultPlayerStrumX3 + 130, 0.25)	
			noteTweenY('defaultPlayerStrumY'..i, i + 4, (defaultPlayerStrumY3 + (285 + (i * 80))) + 30, 0.25)	
		end		
			--Opponent Strum Movement
		for i=0,3 do
			noteTweenX('defaultOpponentStrumX'..i, i, defaultPlayerStrumX3 +130, 0.25)	
			noteTweenY('defaultOpponentStrumY'..i, i, (defaultPlayerStrumY3 + (-70 + (i * 80))) + 30, 0.25)
		end
		-- direction
		for i=0,7 do 
		   noteTweenDirection('defaultStrumX'..i, i, -180, 0.1)
		end
        -- angle
		for i=0,7 do
			noteTweenAngle('defaultStrumX2'..i, i, -90, 0.1)
		end
	end
	if (curBeat == 96) and downscroll then
		--Notes Come From The Left
		for i=0,7 do
		   noteTweenDirection('rightScrollShit'..i, i, 0, 0.1)
		end
		--Player Strum Movement
		for i=0,3 do
		   noteTweenX('defaultPlayerStrumX'..i, i + 4, defaultPlayerStrumX3 + 30, 0.25)	
		   noteTweenY('defaultPlayerStrumY'..i, i + 4, (defaultPlayerStrumY3 - (325 + (i * 80))), 0.25)	
		end
		--Opponent Strum Movement
		for i=0,3 do
		   noteTweenX('defaultOpponentStrumX'..i, i, defaultPlayerStrumX3 + 30, 0.25)	
		   noteTweenY('defaultOpponentStrumY'..i, i, (defaultPlayerStrumY3 + (35 - (i * 80))), 0.25)	
		end

		for i=0,7 do
			noteTweenAngle('defaultStrumX2'..i, i, -90, 0.1)
		end
	end
	if (curBeat == 127) then
		for i=0,7 do
		   noteTweenAngle('hahaturnswitch'..i, i, 270, 0.125)	
		end	
	end
	if (curBeat == 288) then
		for i=0,7 do
		   noteTweenAngle('noteFlipA'..i, i, 540, 0.125)	
		end	
	end

	if (curBeat == 159) then
		for i=0,7 do
			noteTweenAngle('hahaturnswitch'..i, i, 0, 0.125)	
		end	
	end
	if curBeat == 159 or curBeat == 320 then --I KNOW THIS IS INEFFICIENT SHUT UP SHUT UP SHUT UP 
		-- @@@@@@@@@@@#%%%%&%%&%%%%&##%%#%%%%@@@@@*        @#@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&  -- no.
		-- @@@@@@@@@@@%%%%%&%&&%&%%%##@@@@@.                %#@@@@@@@@@@&%%%%&&%&&&&&&&&&&&  -- i hate you
		-- @@@@@@@@@@@&&&&&&&&&&@@@@&                       @#@@@@@@@@@@%%&%&&&&&&&&&@@@@@@
		-- @@@@@@@@@@@%&&&&@@@@,                             &#@@@@@@@@@@%%&@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@@@@@                                   @#@@@@@@@@@@@@&@@@@@@@@@@@@@@@
		-- @@@@@@@@@@*,                                       @#@@@@@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@%&,,@###@,                      .&@@&@@@,,,&#&@@@@@@@@@@@@@&&&@@@&@@@@@@
		-- @@@@@@@@@#@,,&@@%,                &@@*,,,,,,,/@,,,%@@#@@@@@@@@@@@@@@@@@@&&&&&&&&
		-- @@@@@@@@@@@%&,,,,,,,,,,,,,,,%@@*,,,,,,,#@@@@@@@@@@@@*,(@@@@@@@@@@@@@@@@@@@&&&&&&
		-- @@@@@@@@@@@@#@,,,,,,,,*@@%,,,,,,,%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@%@@%@,,&@&,,,,,,,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@&&%@@(,,,,,,*@@@@@@@@@@@@@@@@@@@@.@.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@@%,,,,,,/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@,,,,,,*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####* &@@@*@%@@@@@@@@@@@@@@@@@
		-- @@@@@@,,,,,,&@@@@@@@@@@@@@@@@@@@@@@@(,,,,,*&@#.       ,,&@@@%#,*@@@@@@@@@@@@@@@@
		-- @@@,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,&@@@%#@@@@@@@@@@@@@@@@@@
		-- *,,,,*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,@&#/,,#/,,&@@@@@@@@@@@@@@@@@@@@@@@
		-- @/,@@@@@@@@@&@@@@@@@@@@@@@@@@@&#@@@@@@@@@@#@*      %@@*@@@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@           *@@&@@@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@            @@@@@(@,@@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@&&%%&@@@@@@@@@@@@@@@@@@@        .@@@@@@@@@  @&@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@&%%&&@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@    @//@@@@@@@@@@@@@@@@@@@@@@@
		-- @@@@@@@@@@@&%&&@@@@@@@@@@@@@@@@@@@@@@   ...        @/#@@@@@@@@@@@@@@@@@@@@@@@(@@
		-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(      &@,@@@@@@@@@@@@@@@@@@@,,,,,,,,@@@
		-- @@@@@@@@@@@@%,#&%(*,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,@@@@
		-- @@@@@@@@@@@&@%,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#%@@@@@@@@@@@@@@@@@@,(@@@@
		-- @@@@@@@@@@@&&@&,(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#####@&@@@@@@@@@@@@@@,,@@@@@
		-- @@@@@@@@@@@&&&@@,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####%@&&&@@@@@@@@@@@@%,@@#,,,
		-- @@@@@@@@@@@@@#/%@,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####@@&&&&&&@@@@@@@@@@,#@,,,, 
		-- @@@@@@@.    .,,*@@,,%@@@@@@@@@@@@@@@@@@@@@@@@@@@&####@&&&&&&&&&@@@@@@@@,,@%,,,  
		-- @@@@@   ,*@@@@@@@@@,,*@@@@@@@@@@@@@@&@@@@@@@@@@%###&@&&&&&&&&&&@@@@@@@#,@@,,,   
		-- @@*  .,@@@@@@@@@@@@@%,,@@@@@@@@@@@&&&&@@@@@@@@@@@@@@&&&&&&&&&&&&@@@@@@,*@*,,    
		--    ,@@@@@@@@@@@@@@@@@@%,@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@,,@@(,,    
		-- ,@@@@@@@@@@@@@@@@@@@   #@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@,@@#@@,/@@@
		
		
		for i=0,7 do
		   noteTweenDirection('defaultStrumX'..i, i, 90, 0.1)
		   --noteTweenAngle('defaultStrumX2'..i, i, 0, 0.1)
		end

		for i=0,3 do
			noteTweenX('defaultOpponentStrumX'..i, i, _G['defaultOpponentStrumX'..i], 0.25)	
			noteTweenY('defaultOpponentStrumY'..i, i, _G['defaultOpponentStrumY'..i], 0.25)	
		end

		for i=4,7 do
			noteTweenX('defaultPlayerStrumX'..i-4, i, _G['defaultPlayerStrumX'..i-4], 0.25)	
			noteTweenY('defaultPlayerStrumY'..i-4, i, _G['defaultPlayerStrumY'..i-4], 0.25)	
		end
		
	end


	if curBeat == 320 then
        for i=0,7 do
           noteTweenAngle('noteFlipB'..i, i, 0, 0.125)
        end
    end
	
end

function onTweenCompleted(name)
    if name == 'camz' then
        setProperty("defaultCamZoom",getProperty('camGame.zoom')) 
    end  
end