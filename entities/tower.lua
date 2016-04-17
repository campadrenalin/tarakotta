local COOLDOWN = 0.05
local MAX_AMMO = 50
local DEBUG = false

local Entity = require "entities/entity"
local Tower  = setmetatable({
    type = 'tower',
    physics = {
        type = 'static',
        category = 1,
        radius = 8,
    },

    ammo   = 0,
    team   = nil,
    target = nil,
    cooldown = COOLDOWN,
}, Entity);
Tower.__index = Tower

local Bullet = require "entities/bullet"
local Sensor = require "entities/tower_sensor"
require "util/extra_math"

function Tower:configure(body, fixture)
    local x, y = body:getPosition()
    self.sensor = self.level:add(Sensor, x, y, {}):getUserData()
    fixture:setMask(5)
end

function Tower:tag(team)
    if team then
        self.team = team
        self.ammo = MAX_AMMO
    else
        self.team = nil
        self.ammo = 0
    end
    self.target = self.sensor:findEnemyOf(self)
end

function Tower:draw(body)
    self:drawCircle(body, nil, 20, nil)
    if self.ammo > 0 then
        local fill_radius = math.lerp(Bullet.physics.radius, self.physics.radius, self.ammo/MAX_AMMO)
        self:drawCircle(body, fill_radius, 20, nil, "fill")
    end

    -- DEBUG OUTPUT
    if DEBUG then
        local x, y = body:getPosition()
        for k, v in pairs(self.sensor.targets_in_range) do
            local vx, vy = v:getBody():getPosition()
            love.graphics.line(x, y, vx, vy)
            if self.target and v.id == self.target.id then
                love.graphics.circle("fill",
                    math.lerp(x, vx, 0.2),
                    math.lerp(y, vy, 0.2),
                    3, 10)
            end
        end
        love.graphics.print(self.cooldown, x + self.physics.radius*2, y)
    end

end

function Tower:beginContact(my_fixture, their_fixture, collision)
    local other = their_fixture:getUserData()
    if other.physics.category == 3 then -- player
        self:tag(other.team)
    elseif other.physics.category == 2 then -- bullet
        collision:setEnabled(other.sent)
    end
end

function Tower:update(body, dt)
    if self.team == nil then return end
    if self.ammo <= 0 then
        self:tag(nil)
    end
    if math.random(0, MAX_AMMO*1200*dt) < self.ammo then self:fireBullet(body) end
    if self.sensor.dirty then
        self.target = self.sensor:findEnemyOf(self)
    end
    if self.target == nil then return end

    self.cooldown = self.cooldown - dt
    if self.cooldown < 0 then
        self:fireBullet(body)
    end
end

function Tower:fireBullet(b)
    self.cooldown = COOLDOWN - self.cooldown
    if self.ammo < 1 then return end
    self.ammo = self.ammo - 1

    local bullet_fixture = self.level:add(Bullet, b:getX(), b:getY(), {
        team   = self.team,
        motionCompensation = 0.1 + math.sin(self.ammo/50)*0.1, -- sweep between 0 and .2 over time
    })
    local bullet = bullet_fixture:getUserData()
    local bullet_body = bullet_fixture:getBody()

    if self.target and not self.target:isDestroyed() then
        bullet:fireAt(bullet_body, 7, self.target:getBody())
    else
        bullet:fireRandom(bullet_body, math.random(1,2))
    end
end

return Tower
