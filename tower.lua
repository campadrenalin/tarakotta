local Tower = {}
Tower.__index = Tower

local Bullet = require "bullet"

local RADIUS = 8
local COOLDOWN = 0.1

function Tower.new(world, x, y)
	local tower = setmetatable({}, Tower)
	tower.body    = love.physics.newBody(world, x, y, "static")
	tower.shape   = love.physics.newCircleShape(RADIUS);
	tower.fixture = love.physics.newFixture(tower.body, tower.shape)

    tower.cooldown = COOLDOWN

	-- Circular reference, be sure to explicitly delete
	tower.body:setUserData(tower)

	return tower
end

function Tower:draw()
	love.graphics.circle("line", self.body:getX(), self.body:getY(), RADIUS, 20)
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
    local bullet = Bullet.new(
        b:getWorld(),
        b:getX(),
        b:getY()
    )
    bullet.body:applyLinearImpulse(
        love.math.random(-5, 5),
        love.math.random(-5, 5)
    )
end


return Tower
