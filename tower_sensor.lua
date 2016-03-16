local Entity = require "entity"
local Sensor  = setmetatable({}, Entity);
Sensor.__index = Sensor
Sensor.physics_category = 4

local RADIUS = 128

function Sensor.new(world, x, y, tower)
    local sensor = Entity.new(Sensor, world, x, y, RADIUS, "static")
    sensor.fixture:setMask(2)
    sensor.fixture:setSensor(true)

    sensor.tower = tower
    return sensor
end

function Sensor:beginContact(other, collision, alreadyBounced)
    local t = self.tower
    if other.physics_category == 3
            and t.owner ~= nil
            and other.name ~= t.owner.name then
        t.target = other
    end
    if not alreadyBounced then
        return other:beginContact(self, collision, true)
    end
end
function Sensor:endContact(other, collision, alreadyBounced)
    if other.physics_category == 3 then
        self.tower.target = nil
    end
    if not alreadyBounced then
        return other:endContact(self, collision, true)
    end
end

return Sensor
