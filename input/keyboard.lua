local KeyboardInput = {}
KeyboardInput.__index = KeyboardInput
KeyboardInput.mappings = {
    arrows = {
        up    = "up",
        down  = "down",
        left  = "left",
        right = "right",
    },
    wasd = {
        w = "up",
        s = "down",
        a = "left",
        d = "right",
    },
}

function KeyboardInput.new(mapping)
    if type(mapping) == "string" then
        mapping = KeyboardInput.mappings[mapping]
    end
    return setmetatable({
        mapping = mapping,
        down    = {},
    }, KeyboardInput)
end

function KeyboardInput:update()
    local down = {}
    for real, symbolic in pairs(self.mapping) do
        if love.keyboard.isDown(real) then
            down[symbolic] = true
        end
    end
    self.down = down
end
function KeyboardInput:isDown(symbolic)
    return self.down[symbolic] or false
end
function KeyboardInput:value(symbolic, ifyes, ifno)
    if self.down[symbolic] then
        return ifyes
    else
        return ifno
    end
end

return KeyboardInput
