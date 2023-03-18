function onUpdatePost()
	if curBeat == 31 then
		doTweenAlpha(getProperty('camHUD'), getProperty('camHUD'), 1, 0.25)
	end
	if curBeat == 0 then
		doTweenAlpha(getProperty('camHUD'), getProperty('camHUD'), 0, 0.1)
	end
	if curBeat == 224 then
		doTweenAlpha(getProperty('camHUD'), getProperty('camHUD'), 0, 1)
	end
end