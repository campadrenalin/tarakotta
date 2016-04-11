local Entity = require "entities/entity"
local Bullet = setmetatable({
    type = 'bullet',
    physics = {
        type = 'dynamic',
        category = 2,
        radius = 2,
    },

    ttl = 0.5,
    sent = false,
    motionCompensation = 0,
}, Entity);
Bullet.__index = Bullet

function Bullet:fireAt(body, speed, target)
    local mc = self.motionCompensation
    local vx, vy = target:getLinearVelocity()
    local bx, by = body:getPosition()
    local tx, ty = target:getPosition()
    local angle = math.angle(bx, by, tx + mc*vx, ty + mc*vy)
    return self:fire(body, speed, angle)
end
function Bullet:fireRandom(body, speed)
    self:fire(body, speed, math.random(0, 2*math.pi))
end
function Bullet:fire(body, speed, angle)
    speed = speed or math.random(3, 9)
    body:applyLinearImpulse(
        speed * math.cos(angle),
        speed * math.sin(angle)
    )
end

function Bullet:draw(body)
    self:drawCircle(body, nil, 9, nil, "fill")
end
function Bullet:update(body, dt)
    self.ttl = self.ttl - dt
    if self.ttl < 0 then
        body:destroy()
    end
end

function Bullet:endContact()
    self.sent = true
end

return Bullet
