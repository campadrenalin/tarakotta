local colors = require('util/colors')
local Entity = {}
Entity.__index = Entity
Entity.color = colors.white
Entity.type  = 'entity'

function Entity:makeShape()
    return love.physics.newCircleShape(self.physics.radius)
end
function Entity:makeBody(world, x, y)
    return love.physics.newBody(world, x, y, self.physics.type)
end
function Entity:configure(body, fixture) end

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

function Entity:drawCircle(body, radius, quality, c, style)
    style  = style  or "line"
    radius = radius or self.physics.radius
    colors.drawIn(self:getColor(c))
    love.graphics.circle(style, body:getX(), body:getY(), radius, quality)
end

function Entity:beginContact(other, collision) end
function Entity:endContact(other, collision) end

return Entity
