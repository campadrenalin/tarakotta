local Entity = require "entity"
local Bullet = setmetatable({}, Entity);
Bullet.__index = Bullet
Bullet.physics_category = 2
Bullet.radius = 2

function Bullet.new(world, x, y)
    local bullet = Entity.new(Bullet, world, x, y, Bullet.radius, "dynamic")
    bullet.fixture:setMask(1)
    bullet.body:setBullet(true)

    bullet.ttl = 2
    return bullet
end

function Bullet:draw()
    self:drawCircle(Bullet.radius, 9, nil, "fill")
end
function Bullet:update(dt)
    self.ttl = self.ttl - dt
    if self.ttl < 0 then
        self:destroy()
    end
end

return Bullet
