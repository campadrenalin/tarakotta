Tower = {}
Tower.__index = Tower

local RADIUS = 16

function Tower.new(world, x, y)
	local tower = setmetatable({}, Tower)
	tower.body    = love.physics.newBody(world, x, y, "static")
	tower.shape   = love.physics.newCircleShape(RADIUS);
	tower.fixture = love.physics.newFixture(tower.body, tower.shape)

	-- Circular reference, be sure to explicitly delete
	tower.body:setUserData(tower)

	return tower
end

function Tower:draw()
	love.graphics.circle("line", self.body:getX(), self.body:getY(), RADIUS, 20)
end

return Tower
