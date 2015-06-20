Player = {}
Player.__index = Player

function Player.new( spawn_x, spawn_y )
	local p = {}
	setmetatable(p, Player)

	p.x = spawn_x
	p.y = spawn_y

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
