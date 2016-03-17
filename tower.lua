local Entity = require "entity"
local Tower  = setmetatable({}, Entity);
Tower.__index = Tower
Tower.physics_category = 1

local Bullet = require "bullet"
local Sensor = require "tower_sensor"
require "extra_math"

local RADIUS = 8
local SENSOR_RADIUS = 128
local COOLDOWN = 0.05
local MAX_AMMO = 100

-- TODO: Limited ammo
-- TODO: Track multiple ongoing encroachments
function Tower.new(world, x, y)
    local tower  = Entity.new(Tower, world, x, y, RADIUS, "static")
    tower.sensor = Sensor.new(world, x, y, tower)
    tower.fixture:setMask(2)

    tower.ammo   = 0
    tower.owner  = nil
    tower.target = nil
    tower.cooldown = COOLDOWN
    return tower
end

function Tower:setOwner(owner)
    self.owner = owner
    self.color = owner.color
    self.ammo  = MAX_AMMO
end

function Tower:draw()
    self:drawCircle(RADIUS, 20)
end

function Tower:beginContact(other, collision, alreadyBounced)
    if other.physics_category == 3 then
        self:setOwner(other)
    end
    if not alreadyBounced then
        return other:beginContact(self, collision, true)
    end
end

function Tower:update(dt)
    if self.target == nil then return end

    self.cooldown = self.cooldown - dt
    if self.cooldown < 0 then
        self.cooldown = COOLDOWN - self.cooldown
        self:fireBullet(self.target)
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
    bullet.color = self.color
end

return Tower
