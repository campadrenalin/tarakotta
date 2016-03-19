local Registry = {}
Registry.__index = Registry

function Registry.new()
    return setmetatable({ nextID = 1 }, Registry)
end

function Registry:add(object)
    local id = self.nextID
    object.id = id
    self[id] = object
    self.nextID = id + 1
end

function Registry:remove(object)
    self[object.id] = nil
end

function Registry:drawAll()
    for k,v in pairs(self) do
        if k ~= "nextID" then
            v:draw()
        end
    end
end

function Registry:updateAll(dt)
    for k,v in pairs(self) do
        if k ~= "nextID" then
            if v.destroyed then
                v:_destroy()
            else
                v:update(dt)
            end
        end
    end
end

return Registry
