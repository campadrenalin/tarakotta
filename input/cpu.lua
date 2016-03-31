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
    local d = self.draws
    colors.drawIn(colors.green)
    love.graphics.rectangle("line", d.x - BOX_SIZE, d.y - BOX_SIZE, BOX_SIZE * 2, BOX_SIZE * 2)
    for i, target in ipairs(d.targets) do
        if not target.destroyed then
            love.graphics.line(d.x, d.y, target.body:getX(), target.body:getY())
            print(target.type)
        end
    end
    if d.targets.best then
        local target = d.targets.best
        colors.drawIn(colors.red)
        love.graphics.line(d.x, d.y, target.body:getX(), target.body:getY())
    end
end
function CpuInput:update(dt, owner)
    local d = self.draws
    d.targets = {}
    d.x = owner:getX()
    d.y = owner:getY()

    local bestTarget = { -- single thing to go towards
        target   = nil,
        distance = 1000000,
    }
    local scurry = { x = math.random(-2,2), y = math.random(-2,2) } -- aggregate of "run away" velocity
    owner.level.world:queryBoundingBox(
        d.x - BOX_SIZE, d.y - BOX_SIZE, d.x + BOX_SIZE, d.y + BOX_SIZE,
        function(fixture)
            local target = fixture:getBody():getUserData()
            if target.type ~= "tower"
                or target:getX() > love.graphics.getWidth() - 20
                or target:getY() > love.graphics.getHeight() - 20
                    then return true end
            table.insert(d.targets, target)
            if target:teamName() == nil then
                local dist = math.object_angle(owner, target)
                if dist < bestTarget.distance then
                    bestTarget.target = target
                end
            elseif owner:isEnemy(target) then
                print(target.type)
                scurry.x = scurry.x + (d.x - target:getX())/20
                scurry.y = scurry.y + (d.y - target:getY())/20
            end
            return true
        end
    )
    if bestTarget.target ~= nil then
        d.targets.best = bestTarget.target
        local tx, ty = math.vector_xy(math.object_angle(owner, bestTarget.target), 10)
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
