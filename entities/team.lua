local colors = require('util/colors')
local Entity = require "entities/entity"
local Team   = setmetatable({
    SCORE_INTERVAL = 1,

    score = 0,
    lastScoreDelta = 0,
    countdown = 1, -- Team.SCORE_INTERVAL
}, Entity);
Team.__index = Team

function Team.new(props)
    local team = setmetatable(props, Team)
    team.team = team
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
    --[[
    for k, v in ipairs(self.level.registry.items) do
        if v.type == 'tower' and self:isFriendly(v) then
            delta = delta + 1
        end
    end
    --]]
    self.lastScoreDelta = delta
    self.score = self.score + delta
end

return Team
