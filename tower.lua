local Entity = require "entity"
local Tower  = setmetatable({}, Entity);
Tower.__index = Tower
Tower.physics_category = 1

local Bullet = require "bullet"
require "extra_math"

local RADIUS = 8
local SENSOR_RADIUS = 128
local COOLDOWN = 0.05

function Tower.new(world, x, y)
    local tower = Entity.new(Tower, world, x, y, RADIUS, "static")
    tower.fixture:setMask(2)

    tower.sensor = {}
    tower.sensor.shape   = love.physics.newCircleShape(SENSOR_RADIUS);
    tower.sensor.fixture = love.physics.newFixture(tower.body, tower.sensor.shape)
    tower.sensor.fixture:setCategory(1)
    tower.sensor.fixture:setMask(2)
    tower.sensor.fixture:setSensor(true)

    tower.target = nil
    tower.cooldown = COOLDOWN
    return tower
end

function Tower:draw()
    self:drawCircle(RADIUS, 20,   235, 235, 235)
end

function Tower:update(dt)
    if self.target == nil then return end

    self.cooldown = self.cooldown - dt
    if self.cooldown < 0 then
        self.cooldown = COOLDOWN - self.cooldown
        self:fireBullet(self.target)
    end
end

function Tower:beginContact(other, collision, alreadyBounced)
    if other.physics_category == 3 then
        self.target = other
    end
    if not alreadyBounced then
        return other:beginContact(self, collision, true)
    end
end
function Tower:endContact(other, collision, alreadyBounced)
    if other.physics_category == 3 then
        self.target = nil
    end
    if not alreadyBounced then
        return other:endContact(self, collision, true)
    end
end


function Tower:fireBullet(target)
    local b  = self.body
    local bt = target.body
    local bullet = Bullet.new(self.world, b:getX(), b:getY())
    local angle  = math.angle(b:getX(), b:getY(), bt:getX(), bt:getY())
    local speed = 7
    bullet.body:applyLinearImpulse(
        speed * math.cos(angle),
        speed * math.sin(angle)
    )
end

return Tower
