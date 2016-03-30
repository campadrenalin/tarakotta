local Input = {}
Input.__index = Input

function Input:draw() end
function Input:update(dt) end
function Input:isDown() return false end

function Input:value(symbolic, ifyes, ifno)
    if self:isDown(symbolic) then
        return ifyes
    else
        return ifno
    end
end

return Input
