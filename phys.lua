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

function HitBox:setPos(x, y, z)
	local xsize = self.x2 - self.x1
	local ysize = self.y2 - self.y1
	local zsize = self.z2 - self.z1

	self.x1 = x
	self.x2 = x + xsize

	self.y1 = y
	self.y2 = y + ysize

	self.z1 = z
	self.z2 = z + zsize
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

-- Implemented from http://stackoverflow.com/a/3235902 
function HitBox:castRay(x1,y1,z1,x2,y2,z2)
	if x2 < self.x1 and x1 < self.x1 then return false end
	if x2 > self.x2 and x1 > self.x2 then return false end
	if y2 < self.y1 and y1 < self.y1 then return false end
	if y2 > self.y2 and y1 > self.y2 then return false end
	if z2 < self.z1 and z1 < self.z1 then return false end
	if z2 > self.z1 and z1 > self.z2 then return false end
	if x1 > self.x1 and x1 < self.x2 and
		y1 > self.y1 and y1 < self.y2 and
		z1 > self.z1 and z1 < self.z2 then

		return true,x1,x2,z1
	end

	hit = {0,0,0}
	if getIntersection(x1 - self.x1, x2 - self.x1, x1,y1,z1, x2,y2,z2, hit) and
		inBox(hit[1],hit[2],hit[3], self.x1, self.y1, self.z1, self.x2,self.y2,self.z2, 1) or
		getIntersection(y1 - self.y1, y2 - self.y1, x1,y1,z1, x2,y2,z2, hit) and
		inBox(hit[1],hit[2],hit[3], self.x1, self.y1, self.z1, self.x2,self.y2,self.z2, 2) or
		getIntersection(z1 - self.z1, z2 - self.z1, x1,y1,z1, x2,y2,z2, hit) and
		inBox(hit[1],hit[2],hit[3], self.x1, self.y1, self.z1, self.x2,self.y2,self.z2, 3) or
		getIntersection(x1 - self.x2, x2 - self.x2, x1,y1,z1, x2,y2,z2, hit) and
		inBox(hit[1],hit[2],hit[3], self.x1, self.y1, self.z1, self.x2,self.y2,self.z2, 1) or
		getIntersection(y1 - self.y2, y2 - self.y2, x1,y1,z1, x2,y2,z2, hit) and
		inBox(hit[1],hit[2],hit[3], self.x1, self.y1, self.z1, self.x2,self.y2,self.z2, 2) or
		getIntersection(z1 - self.z2, z2 - self.z2, x1,y1,z1, x2,y2,z2, hit) and
		inBox(hit[1],hit[2],hit[3], self.x1, self.y1, self.z1, self.x2,self.y2,self.z2, 3) then

		return true,hit[1],hit[2],hit[3]
	end
	return false
end

function getIntersection(fDist1, fDist2, x1,y1,z1, x2,y2,z2, hit)
	if (fDist1 * fDist2) >= 0 then return false end
	if (fDist1 == fDist2) then return false end
	local scale = (-fDist1)/(fDist2-fDist1)
	hit[1] = x1 + (x2-x1)*scale
	hit[2] = y1 + (y2-y1)*scale
	hit[3] = z1 + (z2-z1)*scale
	return true
end

function inBox(x1,y1,z1, x2,y2,z2, x3,y3,z3, axis)
	if axis == 1 and z1 > z2 and z1 < z3 and y1 > y2 and y1 < y3 then
		return true
	end
	if axis == 2 and z1 > z2 and z1 < z3 and x1 > x2 and x1 < x3 then
		return true
	end
	if axis == 3 and x1 > x2 and x1 < x3 and y1 > y2 and y1 < y3 then
		return true
	end
	return false
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
