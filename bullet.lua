local Entity = require "entity"
local Bullet = setmetatable({}, Entity);
Bullet.__index = Bullet

local RADIUS = 2

function Bullet.new(world, x, y)
	local bullet = Entity.new(Bullet, world, x, y, RADIUS, "dynamic")
	bullet.ttl = 2
	return bullet
end

function Bullet:draw()
    self:drawCircle(RADIUS, 9,   255, 255, 255)
end
function Bullet:update(dt)
    self.ttl = self.ttl - dt
    if self.ttl < 0 then
        self:destroy()
    end
end

return Bullet
