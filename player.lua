require("phys")

Player = {}
Player.__index = Player

playerSize = 32

function Player.new( xOnWindow, yOnWindow )
	local p = {}
	setmetatable(p, Player)

	p.x = 0
	p.y = 0

	p.oldx = 0
	p.oldy = 0

	p.velx = 0
	p.vely = 0

	p.angle = 0

	p.hitbox = HitBox.new(0, 0, 0, playerSize, playerSize, layerHeight)

	p.xOnWindow = xOnWindow
	p.yOnWindow = yOnWindow

	return p
end

function Player:setPos(x, y)
	self.x = x
	self.y = y
	self.hitbox:setPos(self.x, self.y, 0)
end

function Player:resetPos(x, y)
	self.x = self.oldx
	self.y = self.oldy
	self.hitbox:setPos(self.x, self.y, 0)
end

function Player:update(delta)
	self.hitbox:setRot(self.angle)
	self.oldx = self.x
	self.oldy = self.y
	self.x = self.x + self.velx*delta
	self.y = self.y + self.vely*delta
	self.hitbox:setPos(self.x, self.y, 0)
end

function Player:draw()
	love.graphics.push()
	--love.graphics.origin()
	love.graphics.translate(self.x+playerSize/2, self.y+playerSize/2)
	love.graphics.rotate(self.angle)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle("fill", -playerSize/2, -playerSize/2, 
							playerSize, playerSize)
	love.graphics.pop()
end
