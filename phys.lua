HitBox = {}
HitBox.__index = HitBox

function subVec(v1, v2)
	return({v1[1]-v2[1], v1[2]-v2[2], v1[3]-v2[3]})
end

function addVec(v1,v2)
	return({v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3]})
end

function rotate(p, angle)
	return {p[1]*math.cos(angle) - p[2]*math.sin(angle),
			p[1]*math.sin(angle) + p[2]*math.cos(angle)}
end

function Vector(x,y,z)
	return {x,y,z}
end

function Dot(v1,v2)
	return v1[1]*v2[1]+v1[2]*v2[2]+v1[3]*v2[3]
end

function Scalar(s,v)
	return {s*v[1],s*v[2],s*v[3]}
end

function Normalize(v)
	local mag = math.sqrt(Dot(v,v))
	return {v[1]/mag, v[2]/mag, v[3]/mag} 
end

function HitBox.new(x1, y1, z1, x2, y2, z2)
	local hb = {}
	setmetatable(hb, HitBox)
	
	-- Set hitbox properties
	hb.u = {Vector(1,0,0), Vector(0,1,0), Vector(0,0,1)}
	hb.e = Vector((x2-x1)/2, (y2-y1)/2, (z2-z1)/2)
	hb.c = Vector(x1+hb.e[1], y1+hb.e[2], z1+hb.e[3])
	return hb
end

function HitBox:setPos(x, y, z)
	self.c[1] = x+self.e[1]
	self.c[2] = y+self.e[2]
	self.c[3] = z+self.e[3]
end

function HitBox:checkCollision(box)
	return testOBB(self, box)
end

-- TODO Change containsPoint and castRay to work with OBB
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

epsilon = 5.96e-08 
function testOBB(a,b)
	local ra,rb = 0,0
	local R = {Vector(1,0,0),Vector(0,1,0),Vector(0,0,1)}
	local AbsR = {Vector(1,0,0),Vector(0,1,0),Vector(0,0,1)}

	for i=1,3 do
		for j=1,3 do
			R[i][j] = Dot(a.u[i], b.u[j])
		end
	end

	local t = subVec(b.c, a.c)
	t = Vector(Dot(t, a.u[1]), Dot(t, a.u[2]), Dot(t, a.u[3]))

	for i=1,3 do
		for j=1,3 do
			AbsR[i][j] = math.abs(R[i][j]) + epsilon
		end
	end

	for i=1,3 do
		ra = a.e[i]
		rb = b.e[1]*AbsR[i][1] + b.e[2]*AbsR[i][2]+b.e[3]*AbsR[i][3]
		if math.abs(t[i]) > ra + rb then return false end
	end

	for i=1,3 do
		ra = a.e[1]*AbsR[1][i] + a.e[2]*AbsR[2][i] + a.e[3]*AbsR[3][i]
		rb = b.e[i]
		if math.abs(t[1]*R[1][i] + t[2]*R[2][i] + t[3]*R[3][i]) > ra+rb then
			return false
		end
	end

	ra = a.e[2]*AbsR[3][1] + a.e[3]*AbsR[2][1]
	rb = b.e[2]*AbsR[1][3] + b.e[3]*AbsR[1][2]
	if math.abs(t[3]*R[2][1] - t[2]*R[3][1]) > ra+rb then return 0 end

	ra = a.e[2]*AbsR[3][2] + a.e[3]*AbsR[2][2]
	rb = b.e[1]*AbsR[1][3] + b.e[3]*AbsR[1][1]
	if math.abs(t[3]*R[2][2] - t[2]*R[3][1]) > ra+rb then return 0 end

	ra = a.e[2]*AbsR[3][3] + a.e[3]*AbsR[2][3]
	rb = b.e[1]*AbsR[1][2] + b.e[2]*AbsR[1][1]
	if math.abs(t[3]*R[2][3] - t[2]*R[3][3]) > ra+rb then return 0 end

	ra = a.e[1]*AbsR[3][1] + a.e[3]*AbsR[1][1]
	rb = b.e[2]*AbsR[2][3] + b.e[3]*AbsR[2][2]
	if math.abs(t[1]*R[3][1] - t[3]*R[1][1]) > ra+rb then return 0 end

	ra = a.e[1]*AbsR[3][2] + a.e[3]*AbsR[1][2]
	rb = b.e[1]*AbsR[2][3] + b.e[3]*AbsR[2][1]
	if math.abs(t[1]*R[3][2] - t[3]*R[1][2]) > ra+rb then return 0 end

	ra = a.e[1]*AbsR[3][3] + a.e[3]*AbsR[1][3]
	rb = b.e[1]*AbsR[2][2] + b.e[2]*AbsR[2][1]
	if math.abs(t[1]*R[3][3] - t[3]*R[1][2]) > ra+rb then return 0 end

	ra = a.e[1]*AbsR[2][1] + a.e[2]*AbsR[1][1]
	rb = b.e[1]*AbsR[3][3] + b.e[3]*AbsR[3][2]
	if math.abs(t[2]*R[1][1] - t[1]*R[2][1]) > ra+rb then return 0 end

	ra = a.e[1]*AbsR[2][2] + a.e[2]*AbsR[1][2]
	rb = b.e[1]*AbsR[3][3] + b.e[3]*AbsR[3][1]
	if math.abs(t[2]*R[1][2] - t[1]*R[2][2]) > ra+rb then return 0 end

	ra = a.e[1]*AbsR[2][3] + a.e[2]*AbsR[1][3]
	rb = b.e[1]*AbsR[3][2] + b.e[2]*AbsR[3][1]
	if math.abs(t[2]*R[1][3] - t[1]*R[2][3]) > ra+rb then return 0 end

	return true
end
