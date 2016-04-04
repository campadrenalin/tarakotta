local colors = require('util/colors')
local Entity = require "entities/entity"
local Team   = setmetatable({}, Entity);
Team.__index = Team
Team.SCORE_INTERVAL = 1

function Team.new(level, x, y, properties)
    local team = Entity.new(Team, level, x, y, properties)
    team.score = 0
    team.lastScoreDelta = 0
    team.countdown = Team.SCORE_INTERVAL
    team.team = team -- Helper for superclass methods

    return team
end

function Team:spawn(x, y, properties)
    properties.team = self
    return self.level:add('spawn', x, y, properties)
end

function Team:draw()
    local text = self.name .. " : " .. self.score .. " (+" .. self.lastScoreDelta .. ")"
    local cycle = self.countdown/self.SCORE_INTERVAL
    local shudder = math.floor(10*math.sin(cycle*60) * math.max(0, cycle-0.5))

    -- Paint shadow first, underneath
    colors.drawIn(colors.white)
    love.graphics.print(text, self.x - 1, self.y + shudder - 1)
    colors.drawIn(colors.black)
    love.graphics.print(text, self.x + 1, self.y + shudder + 1)

    -- Colored version
    colors.drawIn(colors.lerp(self.color, colors.white, cycle * cycle))
    love.graphics.print(text, self.x, self.y + shudder)
end

function Team:update(dt)
    self.countdown = self.countdown - dt
    if self.countdown > 0 then return end

    self.countdown = self.countdown + self.SCORE_INTERVAL
    local delta = 0
    for k, v in ipairs(self.level.registry.items) do
        if v.type == 'tower' and self:isFriendly(v) then
            delta = delta + 1
        end
    end
    self.lastScoreDelta = delta
    self.score = self.score + delta
end

return Team
