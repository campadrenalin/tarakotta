local Input = require "input/base"
local CpuInput = setmetatable({}, Input)
CpuInput.__index = CpuInput

function CpuInput.new()
    return setmetatable({}, CpuInput)
end
function CpuInput:isDown(symbolic)
    return math.random(0, 2) > 1
end

return CpuInput
