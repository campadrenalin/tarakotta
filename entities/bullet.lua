local Entity = require "entities/entity"
local Bullet = setmetatable({}, Entity);
Bullet.__index = Bullet
Bullet.physics = {
    type = 'dynamic',
    category = 2,
    radius = 2,
}

function Bullet.new(level, x, y)
    local bullet = Entity.new(Bullet, level, x, y)
    bullet.fixture:setMask(1)
    bullet.body:setBullet(true)

    bullet.ttl = 2
    return bullet
end

function Bullet:draw()
    self:drawCircle(self.physics.radius, 9, nil, "fill")
end
function Bullet:update(dt)
    self.ttl = self.ttl - dt
    if self.ttl < 0 then
        self:destroy()
    end
end

return Bullet
