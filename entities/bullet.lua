local Entity = require "entities/entity"
local Bullet = setmetatable({}, Entity);
Bullet.__index = Bullet
Bullet.type = 'bullet'
Bullet.physics = {
    type = 'dynamic',
    category = 2,
    radius = 2,
}

function Bullet.new(level, x, y, properties)
    local bullet = Entity.new(Bullet, level, x, y, properties)
    bullet.body:setBullet(true)

    bullet.ttl = 0.5
    bullet.sent = false
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

function Bullet:endContact()
    self.sent = true
end

return Bullet
