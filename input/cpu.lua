local Input = require "input/base"
local CpuInput = setmetatable({}, Input)
CpuInput.__index = CpuInput

require "util/extra_math"
local colors = require "util/colors"

local THRESHOLD = 1
local BOX_SIZE  = 150

function CpuInput.new()
    return setmetatable({
        draws = { x = 0, y = 0, targets = {} },
        wants = {},
    }, CpuInput)
end
function CpuInput:draw()
    -- self:debugDraw()
end
function CpuInput:debugDraw()
    local d = self.draws
    colors.drawIn(colors.green)
    love.graphics.rectangle("line", d.x - BOX_SIZE, d.y - BOX_SIZE, BOX_SIZE * 2, BOX_SIZE * 2)
    for i, target in ipairs(d.targets) do
        if not target.destroyed then
            love.graphics.line(d.x, d.y, target.body:getX(), target.body:getY())
        end
    end
    if d.targets.best then
        local target = d.targets.best
        colors.drawIn(colors.red)
        love.graphics.line(d.x, d.y, target.body:getX(), target.body:getY())
    end
end
function CpuInput:update(dt, owner, body)
    local d = self.draws
    d.targets = {}
    d.x = body:getX()
    d.y = body:getY()

    local bestTarget = { -- single thing to go towards
        target   = nil,
        distance = 1000000,
    }
    local scurry = { x = math.random(-2,2), y = math.random(-2,2) } -- aggregate of "run away" velocity
    owner.level.world:queryBoundingBox(
        d.x - BOX_SIZE, d.y - BOX_SIZE, d.x + BOX_SIZE, d.y + BOX_SIZE,
        function(fixture)
            local target = fixture:getUserData()
            local tx, ty = fixture:getBody():getPosition()
            if target.type ~= "tower"
                or tx > love.graphics.getWidth() - 20
                or ty > love.graphics.getHeight() - 20
                    then return true end
            table.insert(d.targets, fixture)
            if target:teamName() == nil then
                local dist = math.object_angle(body, fixture:getBody()) + math.random(0, 100)
                if dist < bestTarget.distance then
                    bestTarget.target = fixture
                end
            elseif owner:isEnemy(target) then
                local dampen = 40 + math.random(0, 60)
                scurry.x = scurry.x + (d.x - tx)/dampen
                scurry.y = scurry.y + (d.y - ty)/dampen
            end
            return true
        end
    )
    if bestTarget.target ~= nil then
        d.targets.best = bestTarget.target
        local tx, ty = math.vector_xy(math.object_angle(body, bestTarget.target:getBody()), 10)
        scurry.x = scurry.x + tx
        scurry.y = scurry.y + ty
    end

    self.wants.left  = -scurry.x > THRESHOLD
    self.wants.right =  scurry.x > THRESHOLD
    self.wants.up    = -scurry.y > THRESHOLD
    self.wants.down  =  scurry.y > THRESHOLD
end
function CpuInput:isDown(symbolic)
    return self.wants[symbolic] or false
end

return CpuInput
