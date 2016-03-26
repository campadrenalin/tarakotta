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
    bullet.speed = bullet.speed or math.random(3,9)

    if bullet.target then
        local b  = bullet.body
        local bt = bullet.target.body
        bullet.angle = math.angle(b:getX(), b:getY(), bt:getX(), bt:getY())
    else
        bullet.angle = math.random(0, 2*math.pi)
    end
    bullet.body:applyLinearImpulse(
        bullet.speed * math.cos(bullet.angle),
        bullet.speed * math.sin(bullet.angle)
    )

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
