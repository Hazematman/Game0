maxWindowed = false
maxFullscreen = false

function makeWindow()
	maxWidth, maxHeight = love.window.getDesktopDimensions( 1 )
	local customWidth, customHeight = 1280, 720
	
	if maxWindowed then
		love.window.setMode( maxWidth, maxHeight, 
							 { borderless = true, centered = true, display = 1 } )
	elseif maxFullscreen then
		love.window.setMode( maxWidth, maxHeight, { fullscreen = true, display = 1 } )
	else
		love.window.setMode( customWidth, customHeight,
							 { centered = true } )
	end
end
