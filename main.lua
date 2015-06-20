require("ai")

-- All Initilization code goes here
ai = nil
function love.load()
	ai = Ai.new()
end

function love.update(delta)
end

function love.draw()
	love.graphics.print("Go Kosmotron!", 200, 200)
	ai:draw()
end
