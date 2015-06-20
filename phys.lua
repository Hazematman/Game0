HitBox = {}
HitBox.__index = HitBox

function HitBox.new(x1, y1, z1, x2, y2, z2)
	local hb = {}
	setmetatable(hb, HitBox)
	
	-- Set hitbox properties
	hb.x1 = x1
	hb.x2 = x2
	hb.y1 = y1
	hb.y2 = y2
	hb.z1 = z1
	hb.z2 = z2
	return hb
end

function HitBox:checkCollision(box)
	return self.x2 > box.x1 and
	       self.x1 < box.x2 and
		   self.y2 > box.y1 and
		   self.y1 < box.y2 and
		   self.z2 > box.z1 and
		   self.z1 < box.z2
end

function HitBox:containsPoint(x, y, z)
	if x < self.x1 or x > self.x2 then
		return false
	elseif y < self.y1 or y > self.y2 then
		return false
	elseif z < self.x1 or z > self.z2 then
		return false
	end

	return true
end

-- A Hit Map contains a list of hit boxes and handles collision inside them
HitMap = {}
HitMap.__index = HitMap

function HitMap.new()
	local hm = {}
	setmetatable(hm, HitMap)

	hm.boxes = {}
	return hm
end

function HitMap:checkCollision(box)
	for k,v in pairs(self.boxes) do
		if v:checkCollision(box) == true then
			return true
		end
	end
	return false
end

function HitMap:containsPoint(x, y, z)
	for k,v in pairs(self.boxes) do
		if v:containsPoint(x, y, z) == true then
			return true
		end
	end
	return false
end

function HitMap:addBox(box)
	table.insert(self.boxes, box)
end
