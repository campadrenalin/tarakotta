local Input = require "input/base"
local CpuInput = setmetatable({}, Input)
CpuInput.__index = CpuInput

-- Dimensions of "vision" bounding box, in offsets from player
local WIDTH  = 25  -- Perpendicular to vision direction
local HEIGHT = 100 -- Parallel to vision direction
CpuInput.bounds = {
    up = {
        tlx = -WIDTH,
        tly = -HEIGHT,
        brx =  WIDTH,
        bry =  0,
    },
    down = {
        tlx = -WIDTH,
        tly =  0,
        brx =  WIDTH,
        bry =  HEIGHT,
    },
    left = {
        tlx = -HEIGHT,
        tly = -WIDTH,
        brx =  0,
        bry =  WIDTH,
    },
    right = {
        tlx =  0,
        tly = -WIDTH,
        brx =  HEIGHT,
        bry =  WIDTH,
    },
}

function CpuInput.new()
    return setmetatable({
        draws = { x = 0, y = 0, targets = {} },
        wants = {},
    }, CpuInput)
end
function CpuInput:getDirectionScore(name, owner)
    local b = self.bounds[name]
    if b == nil then
        return false
    end
    local x, y = owner.body:getPosition()
    local score = 0
    owner.level.world:queryBoundingBox(
        x + b.tlx,
        y + b.tly,
        x + b.brx,
        y + b.bry,
        function(fixture)
            local target = fixture:getBody():getUserData()
            if target.type == "tower" and target:teamName() == nil then
                table.insert(self.draws.targets, target)
                score = score + 1
            end
            return true
        end
    )
    return score
end
function CpuInput:draw()
    local d = self.draws
    for i, target in ipairs(d.targets) do
        love.graphics.line(d.x, d.y, target.body:getX(), target.body:getY())
        print(i)
    end
    if self.scores then
        love.graphics.line(d.x, d.y, d.x, d.y + self.scores.up   * 10)
        love.graphics.line(d.x, d.y, d.x, d.y - self.scores.down * 10)
        love.graphics.line(d.x, d.y, d.x - self.scores.left  * 10, d.y)
        love.graphics.line(d.x, d.y, d.x + self.scores.right * 10, d.y)
    end
end
function CpuInput:update(dt, owner)
    self.draws.targets = {}
    self.draws.x = owner.body:getX()
    self.draws.y = owner.body:getY()

    local scores = {}
    for name, bounds in pairs(self.bounds) do
        scores[name] = self:getDirectionScore(name, owner)
    end

    if scores.up > scores.down then
        self.wants.up = true
        self.wants.down = false
    else
        self.wants.up = false
        self.wants.down = true
    end

    if scores.left > scores.right then
        self.wants.left = true
        self.wants.right = false
    else
        self.wants.left = false
        self.wants.right = true
    end

    self.scores = scores
end
function CpuInput:isDown(symbolic)
    return self.wants[symbolic] or false
end

return CpuInput
