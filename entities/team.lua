local Entity = require "entities/entity"
local Team   = setmetatable({}, Entity);
Team.__index = Team

function Team.new(level, x, y, properties)
    properties.score = 0
    return Entity.new(Team, level, x, y, properties)
end

function Team:spawn(x, y, properties)
    properties.team = self
    return self.level:add('spawn', x, y, properties)
end

function Team:draw()
    local c = self.color
    love.graphics.setColor(c.r, c.g, c.b)
    love.graphics.print(self.name .. " : " .. self.score, self.x, self.y)
end

function Team:update(dt)
end

return Team
