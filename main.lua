require("window")
require("ai")
require("player")
require("level")

speed = 100

-- All Initilization code goes here
function love.load()
	makeWindow()
	level = Level.new()
	level:makeBuildings()
	level:makeBuildings( { { 20, 30, 20, 30, 1 } } )
	ai = Ai.new()
	player = Player.new()
	player:setPos(10,10)
end

function love.update(delta)
	player:update(delta)

	-- Do player physics
	if level.hitmap:checkCollision(player.hitbox) then
		-- TODO get normals for collision to reduce computation
		local oldx = player.oldx
		local oldy = player.oldy
		local newx = player.x
		local newy = player.y
		player:setPos(oldx, newy)
		if level.hitmap:checkCollision(player.hitbox) then
			player.vely = 0
		else
			player.velx = 0
		end
		player:setPos(oldx, oldy)
	end
end


function love.draw()
	love.graphics.origin()
	x,y = love.window.getDimensions()
	mouseX, mouseY = love.mouse.getPosition()
	mouseX = mouseX - x/2 
	mouseY = mouseY - y/2
	angle = math.atan2(mouseY + (yMag or 0), mouseX + (xMag or 0))
	player.angle = angle
	xMag = math.cos( angle ) * 250
	yMag = math.sin( angle ) * 200
	love.graphics.translate( -player.x + x/2 - xMag, -player.y +y/2 - yMag)
	level:draw()
	ai:draw()
	player:draw()
end

function love.keypressed(key)
	-- TODO rescale movement speed for diag
	if key == 'w' then
		player.vely = -speed
	elseif key == 's' then
		player.vely = speed
	elseif key == 'a' then
		player.velx = -speed
	elseif key == 'd' then
		player.velx = speed
	end
end

function love.keyreleased(key)
	--TODO check if other key is down
	if key == 'w' then
		player.vely = 0
	elseif key == 's' then
		player.vely = 0
	elseif key == 'a' then
		player.velx = 0
	elseif key == 'd' then
		player.velx = 0
	end
end
