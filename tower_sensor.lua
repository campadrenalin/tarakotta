local Entity = require "entity"
local Sensor  = setmetatable({}, Entity);
Sensor.__index = Sensor
Sensor.physics_category = 4

local Registry = require "registry"

local RADIUS = 128

function Sensor.new(world, x, y, tower)
    local sensor = Entity.new(Sensor, world, x, y, RADIUS, "static")
    sensor.fixture:setMask(2)
    sensor.fixture:setSensor(true)

    sensor.tower = tower
    sensor.targets_in_range = Registry.new()
    return sensor
end

function Sensor:reconsiderTarget()
    local owner = self.tower.owner
    for k, v in pairs(self.targets_in_range.items) do
        if owner == nil or v.name ~= owner.name then
            self.tower.target = v
            return
        end
    end
    self.tower.target = nil
end

function Sensor:beginContact(other, collision, alreadyBounced)
    if other.physics_category == 3 then
        self.targets_in_range:add(other)
        self:reconsiderTarget()
    end
    if not alreadyBounced then
        return other:beginContact(self, collision, true)
    end
end
function Sensor:endContact(other, collision, alreadyBounced)
    if other.physics_category == 3 then
        self.targets_in_range:remove(other)
        self:reconsiderTarget()
    end
    if not alreadyBounced then
        return other:endContact(self, collision, true)
    end
end

return Sensor
