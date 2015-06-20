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
end

function love.update(delta)
	player:update(delta)
end

function love.draw()
	love.graphics.print("Go Kosmotron!", 200, 200)
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
