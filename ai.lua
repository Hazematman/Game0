Ai = {}
Ai.__index = Ai

function Ai.new()
	local ai = {}
	setmetatable(ai, Ai)

	-- Ai properties
	ai.x = 0
	ai.y = 0
	return ai
end

function Ai:draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", self.x, self.y, 32, 32)
end
