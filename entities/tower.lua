local Entity = require "entities/entity"
local Tower  = setmetatable({}, Entity);
Tower.__index = Tower
Tower.physics = {
    type = 'static',
    category = 1,
    radius = 8,
}

local Bullet = require "entities/bullet"
local Sensor = require "entities/tower_sensor"
require "util/extra_math"

local COOLDOWN = 0.05
local MAX_AMMO = 50
local DEBUG = false

function Tower.new(level, x, y)
    local tower  = Entity.new(Tower, level, x, y)
    tower.sensor = Sensor.new(level, x, y, tower)
    tower.fixture:setMask(5)

    tower.ammo   = 0
    tower.team   = nil
    tower.target = nil
    tower.cooldown = COOLDOWN
    return tower
end

function Tower:tag(team)
    if team then
        self.team = team
        self.ammo = MAX_AMMO
    else
        self.team = nil
        self.ammo = 0
    end
    self.sensor:reconsiderTarget()
end

function Tower:draw()
    self:drawCircle(self.physics.radius, 20, nil)
    if self.ammo > 0 then
        local fill_radius = math.lerp(Bullet.physics.radius, self.physics.radius, self.ammo/MAX_AMMO)
        self:drawCircle(fill_radius, 20, nil, "fill")
    end

    -- DEBUG OUTPUT
    if DEBUG then
        for k, v in self.sensor.targets_in_range:iter() do
            love.graphics.line(self.body:getX(), self.body:getY(), v.body:getX(), v.body:getY())
            if self.target and v.id == self.target.id then
                love.graphics.circle("fill",
                    math.lerp(self.body:getX(), v.body:getX(), 0.2),
                    math.lerp(self.body:getY(), v.body:getY(), 0.2),
                    3, 10)
            end
        end
        love.graphics.print(self.cooldown, self.body:getX() + self.physics.radius*2, self.body:getY())
    end

end

function Tower:beginContact(other, collision)
    if other.physics.category == 3 then -- player
        self:tag(other.team)
    elseif other.physics.category == 2 then -- bullet
        collision:setEnabled(other.sent)
    end
end

function Tower:update(dt)
    if self.ammo <= 0 then
        self:tag(nil)
    end
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
    bullet.team = self.team
end

return Tower
