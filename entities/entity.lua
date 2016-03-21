local Entity = {}
Entity.__index = Entity
Entity.color = { r = 255, g = 255, b = 255, name = 'white' }

function Entity.new(class, level, x, y, properties)
    local entity = setmetatable(properties or {}, class)
    entity.class   = class
    entity.body    = love.physics.newBody(level.world, x, y, entity.physics.type)
    entity.shape   = entity:buildShape()
    entity.fixture = love.physics.newFixture(entity.body, entity.shape)
    entity.level   = level
    entity.destroyed = false

    -- Configure basic physics
    entity.fixture:setCategory(entity.physics.category)

    -- Register for draw/updates
    level.registry:add(entity)

    -- Circular reference, be sure to explicitly delete
    entity.body:setUserData(entity)

    return entity
end

function Entity:buildShape()
    return love.physics.newCircleShape(self.physics.radius)
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
end

function Entity:beginContact(other, collision) end
function Entity:endContact(other, collision) end

return Entity
