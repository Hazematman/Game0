require("phys")

Level = {}
Level.__index = Level

-- Constants
til = 8 --tile size
layerHeight = 10



function Level.new( x, y, layers )
	local level = {}
	setmetatable( level, Level )
	
	level.x = x or 180
	level.y = y or 150
	level.tiles = {}
	for i = 1, level.x * level.y do
		level.tiles[ i ] = 0
	end
	level.layers = layers or 1

	level.hitmap = HitMap.new()
	
	return level
end


function Level:draw()
	for i = 1, self.y do
		for j = 1, self.x do
			cur_tile = self.x * (i - 1) + j
			if self.tiles[ cur_tile ] == 0 then
				love.graphics.setColor( 84, 84, 84 ) 
				love.graphics.rectangle("fill", til * (j - 1), til * (i - 1), 
										til, til )
			elseif self.tiles[ cur_tile ] == 1 then
				love.graphics.setColor ( 255, 255, 255 )
				love.graphics.rectangle("fill", til * (j - 1), til * (i - 1), 
										til, til )
			end
		end
	end
end


-- buildings array to pass in looks like { {y, y-size, x, x-size, layers}, ... }
function Level:makeBuildings( buildings )
	if buildings == nil then 
		for i = 1, self.y do
			for j = 1, self.x do
				if i == 1 or i == self.y
					or j == 1 or j == self.x
				then 
					level.tiles[ (i - 1)*self.x + j ] = 1
					wall = HitBox.new( (j - 1)*til, (i - 1)*til, 0, j*til, i*til, 
						layerHeight * self.layers )
					self.hitmap:addBox( wall )				  
				end
			end
		end
	else
		for k,v in ipairs( buildings ) do
			for i = v[ 1 ], v[ 1 ]+v[ 2 ] do
				for j = v[ 3 ], v[ 3 ]+v[ 4 ] do
					if i == v[ 1 ] or i == (v[ 1 ] + v[ 2 ])
						or j == v[ 3 ] or j == (v[ 3 ] + v[ 4 ])
					then  
						level.tiles[ (i - 1)*self.x + j ] = 1
						wall = HitBox.new( (j - 1)*til, (i - 1)*til, 0, j*til, 
							i*til, layerHeight * v[ 5 ] )
						self.hitmap:addBox( wall )
					end
				end
			end
		end
	end
end


