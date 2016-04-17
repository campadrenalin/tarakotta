local Entity = require "entities/entity"
local Sensor  = setmetatable({
    type = 'tower_sensor',
    physics = {
        type = 'static',
        category = 4,
        radius = 128,
    },
}, Entity);
Sensor.__index = Sensor

local Registry = require "util/registry"

function Sensor:configure(body, fixture)
    fixture:setMask(2)
    fixture:setSensor(true)

    self.targets_in_range = {}
end

function Sensor:reconsiderTarget()
    for k, v in pairs(self.targets_in_range) do
        if self:isEnemy(v) then
            self.tower.target = v
            return
        end
    end
    self.tower.target = nil
end
function Sensor:teamName()
    return self.tower:teamName()
end

function Sensor:beginContact(other, collision)
    if other.physics.category == 3 then
        self.targets_in_range[other.uniq_id] = other
        self:reconsiderTarget()
    end
end
function Sensor:endContact(other, collision)
    if other.physics.category == 3 then
        self.targets_in_range[other.uniq_id] = nil
        self:reconsiderTarget()
    end
end

return Sensor
