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
local MAX_AMMO = 50
local DEBUG = false

function Tower.new(level, x, y)
    local tower  = Entity.new(Tower, level, x, y, RADIUS, "static")
    tower.sensor = Sensor.new(level, x, y, tower)
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
    self.sensor:reconsiderTarget()
end

function Tower:draw()
    self:drawCircle(RADIUS, 20, nil)
    if self.ammo > 0 then
        local fill_radius = math.lerp(Bullet.radius, RADIUS, self.ammo/MAX_AMMO)
        self:drawCircle(fill_radius, 20, nil, "fill")
    end

    -- DEBUG OUTPUT
    if DEBUG then
        for k, v in pairs(self.sensor.targets_in_range.items) do
            love.graphics.line(self.body:getX(), self.body:getY(), v.body:getX(), v.body:getY())
            if self.target and v.name == self.target.name then
                love.graphics.circle("fill",
                    math.lerp(self.body:getX(), v.body:getX(), 0.2),
                    math.lerp(self.body:getY(), v.body:getY(), 0.2),
                    3, 10)
            end
        end
        love.graphics.print(self.cooldown, self.body:getX() + RADIUS*2, self.body:getY())
    end

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
        self:fireBullet(self.target)
    end
end

function Tower:fireBullet(target)
    self.cooldown = COOLDOWN - self.cooldown
    if self.ammo < 1 then return end
    self.ammo = self.ammo - 1

    local b  = self.body
    local bt = target.body
    local bullet = Bullet.new(self.level, b:getX(), b:getY())
    local angle  = math.angle(b:getX(), b:getY(), bt:getX(), bt:getY())
    local speed = 7
    bullet.body:applyLinearImpulse(
        speed * math.cos(angle),
        speed * math.sin(angle)
    )
    bullet.color = self.color
end

return Tower
