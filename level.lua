Level = {}
Level.__index = Level


function Level.new( x, y, layers )
   local level = {}
   setmetatable( level, Level )

   level.x = x or 100
   level.y = y or 100
   level.tiles = {}
   for i = 1, level.x * level.y do
	  if 1 <= i and i <= level.x or level.y*(level.x-1) <= i and i <= level.y*level.x then
		 level.tiles[ i ] = 1
	  else
		 level.tiles[ i ] = 0
	  end
   end
   level.layers = layers or 1
   
   return level
end


function Level:draw()
   for i = 1, self.y do
	  for j = 1, self.x do
		 cur_tile = self.y * (i - 1) + j
		 if self.tiles[ cur_tile ] == 0 then
			love.graphics.setColor( 84, 84, 84 ) 
			love.graphics.rectangle("fill", 4 * (j - 1), 4 * (i - 1), 4, 4 )
		 elseif self.tiles[ cur_tile ] == 1 then
			love.graphics.setColor ( 255, 255, 255 )
			love.graphics.rectangle("fill", 4 * (j - 1), 4 * (i - 1), 4, 4 )
		 end
	  end
   end
end
