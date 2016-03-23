local colors = require('util/colors')
local Entity = {}
Entity.__index = Entity
Entity.color = colors.white
Entity.type  = 'entity'

function Entity.new(class, level, x, y, properties)
    local entity = setmetatable(properties or {}, class)
    entity.class   = class
    entity.level   = level
    entity.destroyed = false
    entity:buildPhysics(x, y)

    return entity
end
function Entity:make(class, x, y, properties)
    return self.level:add(class, x, y, properties)
end

function Entity:buildShape()
    return love.physics.newCircleShape(self.physics.radius)
end
function Entity:buildPhysics(x, y)
    if self.physics == nil then
        -- Simple object with no real physics enabled
        self.x = x
        self.y = y
        return
    end

    -- Add physics-related properties to self
    self.body    = love.physics.newBody(self.level.world, x, y, self.physics.type)
    self.shape   = self:buildShape()
    self.fixture = love.physics.newFixture(self.body, self.shape)

    -- Make this entity type maskable and identifiable
    self.fixture:setCategory(self.physics.category)

    -- Circular reference, be sure to explicitly delete
    self.body:setUserData(self)
end

function Entity:teamName()
    if self.team then
        return self.team.name
    else
        return nil
    end
end
function Entity:isEnemy(other)
    local mine   = self:teamName()
    local theirs = other:teamName()
    return mine and theirs and mine ~= theirs
end
function Entity:isFriendly(other)
    local mine   = self:teamName()
    local theirs = other:teamName()
    return mine and theirs and mine == theirs
end
function Entity:getColor(c)
    local teamColor = self.team and self.team.color
    return c or teamColor or self.color
end

-- Individual methods
function Entity:draw() end
function Entity:update() end

function Entity:drawCircle(radius,quality, c, style)
    style = style or "line"
    colors.drawIn(self:getColor(c))
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
