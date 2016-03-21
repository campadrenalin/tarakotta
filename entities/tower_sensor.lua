local Entity = require "entities/entity"
local Sensor  = setmetatable({}, Entity);
Sensor.__index = Sensor
Sensor.physics = {
    type = 'static',
    category = 4,
    radius = 128,
}

local Registry = require "util/registry"

function Sensor.new(world, x, y, tower)
    local sensor = Entity.new(Sensor, world, x, y)
    sensor.fixture:setMask(2)
    sensor.fixture:setSensor(true)

    sensor.tower = tower
    sensor.targets_in_range = Registry.new()
    return sensor
end

function Sensor:reconsiderTarget()
    local owner = self.tower.owner
    for k, v in self.targets_in_range:iter() do
        if owner == nil or v.name ~= owner.name then
            self.tower.target = v
            return
        end
    end
    self.tower.target = nil
end

function Sensor:beginContact(other, collision)
    if other.physics.category == 3 then
        self.targets_in_range:add(other)
        self:reconsiderTarget()
    end
end
function Sensor:endContact(other, collision)
    if other.physics.category == 3 then
        self.targets_in_range:remove(other)
        self:reconsiderTarget()
    end
end

return Sensor