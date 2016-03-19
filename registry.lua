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
end

function Registry:remove(object)
    self.items[object.id] = nil
end

function Registry:drawAll()
    for k,v in pairs(self.items) do
        v:draw()
    end
end

function Registry:updateAll(dt)
    for k,v in pairs(self.items) do
        if v.destroyed then
            v:_destroy()
        else
            v:update(dt)
        end
    end
end

return Registry
