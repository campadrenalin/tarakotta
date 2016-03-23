local Registry = {}
Registry.__index = Registry

function Registry.new()
    return setmetatable({
        nextID = 1,
        items  = {}
    }, Registry)
end

function Registry:add(object)
    local id = object.id or self.nextID
    object.id = id
    self.items[id] = object
    self.nextID = id + 1
    return object
end

function Registry:remove(object)
    self.items[object.id] = nil
    return object
end

function Registry:iter()
    local i = 0
    local n = self.nextID - 1
    return function()
        while i <= n do
            i = i + 1
            local item = self.items[i]
            if item ~= nil then
                return i, item
            end
        end
    end
end

function Registry:drawAll()
    for k,v in self:iter() do
        v:draw()
    end
end

function Registry:updateAll(dt)
    for k,v in self:iter() do
        if v.destroyed then
            v:_destroy()
            self.items[k] = nil
        else
            v:update(dt)
        end
    end
end

return Registry
