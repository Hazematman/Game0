require("ai")
require("player")
require("level")

speed = 100

-- All Initilization code goes here
function love.load()
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
		player:resetPos()
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
	love.graphics.print("Go Kosmotron!", 200, 200)
	level:draw( player.x, player.y )
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
