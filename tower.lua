local Entity = require "entity"
local Tower  = setmetatable({}, Entity);
Tower.__index = Tower

local Bullet = require "bullet"

local RADIUS = 8
local SENSOR_RADIUS = 64
local COOLDOWN = 0.01

function Tower.new(world, x, y)
    local tower = Entity.new(Tower, world, x, y, RADIUS, "static")
    tower.fixture:setCategory(1)
    tower.fixture:setMask(2)

    tower.sensor = {}
    tower.sensor.shape   = love.physics.newCircleShape(SENSOR_RADIUS);
    tower.sensor.fixture = love.physics.newFixture(tower.body, tower.sensor.shape)
    tower.sensor.fixture:setCategory(1)
    tower.sensor.fixture:setMask(2)
    tower.sensor.fixture:setSensor(true)

    tower.cooldown = COOLDOWN
    return tower
end

function Tower:draw()
    self:drawCircle(RADIUS, 20,   235, 235, 235)
end

function Tower:update(dt)
    self.cooldown = self.cooldown - dt
    if self.cooldown < 0 then
        self.cooldown = COOLDOWN - self.cooldown
        self:fireBullet()
    end
end

function Tower:fireBullet()
    local b = self.body
    local bullet = Bullet.new(self.world, b:getX(), b:getY())
    bullet.body:applyLinearImpulse(
        love.math.random(-5, 5),
        love.math.random(-5, 5)
    )
end

return Tower
