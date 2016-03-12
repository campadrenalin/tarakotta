local Entity = {}
Entity.__index = Entity

function Entity.new(class, world, x, y, radius, phystype)
	local entity = setmetatable({}, class)
	entity.body    = love.physics.newBody(world, x, y, phystype)
	entity.shape   = love.physics.newCircleShape(radius);
	entity.fixture = love.physics.newFixture(entity.body, entity.shape)

	-- Circular reference, be sure to explicitly delete
	entity.body:setUserData(entity)

    return entity
end

function Entity:drawCircle(r,quality, r,g,b)
    love.graphics.setColor(r, g, b)
	love.graphics.circle("line", self.body:getX(), self.body:getY(), r, quality)
end

return Entity
