local Team = {}
Team.__index = Team

function Team.new(level, name, color)
    return setmetatable({
        level = level,
        name  = name,
        color = color,
        score = 0,
    }, Team)
end

function Team:spawn(x, y, properties)
    properties.team = self
    return self.level:add('spawn', x, y, properties)
end

function Team:draw()
end

function Team:update(dt)
end

return Team
