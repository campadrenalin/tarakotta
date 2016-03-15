local Entity = {}
Entity.__index = Entity

function Entity.new(class, world, x, y, radius, phystype)
    local entity = setmetatable({}, class)
    entity.class   = class
    entity.body    = love.physics.newBody(world, x, y, phystype)
    entity.shape   = love.physics.newCircleShape(radius);
    entity.fixture = love.physics.newFixture(entity.body, entity.shape)
    entity.world   = world

    -- Configure basic physics
    entity.fixture:setCategory(entity.physics_category)

    -- Insert into registry
    class.registry = class.registry or { nextID = 1 }
    entity.id = class.registry.nextID
    class.registry[entity.id] = entity
    class.registry["nextID"] = entity.id + 1

    -- Circular reference, be sure to explicitly delete
    entity.body:setUserData(entity)

    return entity
end

-- Individual methods
function Entity:drawCircle(radius,quality, r,g,b)
    love.graphics.setColor(r, g, b)
    love.graphics.circle("line", self.body:getX(), self.body:getY(), radius, quality)
end

function Entity:destroy()
    self.body:destroy()
    self.class.registry[self.id] = nil
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
    if self.registry == nil then
        return
    end
    for k,v in pairs(self.registry) do
        if k ~= "nextID" then
            v:draw()
        end
    end
end
function Entity:updateAll(dt)
    if self.registry == nil then
        return
    end
    for k,v in pairs(self.registry) do
        if k ~= "nextID" then
            v:update(dt)
        end
    end
end

return Entity
