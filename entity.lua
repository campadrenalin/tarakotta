local Entity = {}
Entity.__index = Entity
Entity.color = { r = 255, g = 255, b = 255 }

local Registry = require "registry"

function Entity.new(class, world, x, y, radius, phystype)
    local entity = setmetatable({}, class)
    entity.class   = class
    entity.body    = love.physics.newBody(world, x, y, phystype)
    entity.shape   = love.physics.newCircleShape(radius);
    entity.fixture = love.physics.newFixture(entity.body, entity.shape)
    entity.world   = world
    entity.destroyed = false

    -- Configure basic physics
    entity.fixture:setCategory(entity.physics_category)

    -- Insert into registry
    class.registry = class.registry or Registry.new()
    class.registry:add(entity)

    -- Circular reference, be sure to explicitly delete
    entity.body:setUserData(entity)

    return entity
end

-- Individual methods
function Entity:draw() end
function Entity:update() end

function Entity:drawCircle(radius,quality, c, style)
    c = c or self.color
    style = style or "line"
    love.graphics.setColor(c.r, c.g, c.b)
    love.graphics.circle(style, self.body:getX(), self.body:getY(), radius, quality)
end

function Entity:destroy()
    self.destroyed = true
end
function Entity:_destroy()
    self.body:destroy()
    self.registry:remove(self)
end

function Entity:beginContact(other, collision, alreadyBounced)
    if alreadyBounced then return end
    other:beginContact(self, collision, true)
end
function Entity:endContact(other, collision, alreadyBounced)
    if alreadyBounced then return end
    other:endContact(self, collision, true)
end

-- Class methods
function Entity:drawAll()
    if self.registry ~= nil then
        self.registry:drawAll()
    end
end
function Entity:updateAll(dt)
    if self.registry ~= nil then
        self.registry:updateAll(dt)
    end
end

return Entity
