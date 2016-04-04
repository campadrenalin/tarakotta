local Registry = {}
Registry.__index = Registry

function Registry.new()
    return setmetatable({
        nextUnique = 1,
        size   = 0,
        items  = {},
    }, Registry)
end

function Registry:add(object)
    -- Helper for comparison outside the registry
    object.uniq_id = object.uniq_id or self.nextUnique

    local s = self.size + 1
    self.size = s
    self.items[s] = object
    return object
end
function Registry:remove(id)
    local s = self.size
    -- Replace with last element
    self.items[id] = self.items[s]
    -- Destroy (potentially duplicate) last element
    self.items[s] = nil
    -- Decrement size
    self.size = s - 1
end

function Registry:drawAll()
    for k,v in ipairs(self.items) do
        v:draw()
    end
end

function Registry:updateAll(dt)
    for k,v in ipairs(self.items) do
        if v.destroyed then
            v:_destroy()
            self:remove(k)
        else
            v:update(dt)
        end
    end
end

return Registry
