Player = {}
Player.__index = Player

function Player.new()
	local p = {}
	setmetatable(p, Player)

	p.x = 0
	p.y = 0

	p.velx = 0
	p.vely = 0

	return p
end

function Player:update(delta)
	self.x = self.x + self.velx*delta
	self.y = self.y + self.vely*delta
end

function Player:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", self.x, self.y, 32, 32)
end
