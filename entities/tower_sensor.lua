local Entity = require "entities/entity"
local Sensor  = setmetatable({
    type = 'tower_sensor',
    physics = {
        type = 'static',
        category = 4,
        radius = 128,
    },

    color  = { r = 40, b = 40, g = 40, a = 256 },
    dirty  = true,
}, Entity);
Sensor.__index = Sensor

local Registry = require "util/registry"

function Sensor:configure(body, fixture)
    fixture:setMask(2)
    fixture:setSensor(true)

    self.targets_in_range = {}
end
function Sensor:draw(fixture)
    -- self:drawCircle(fixture, nil, 20)
end

function Sensor:findEnemyOf(entity)
    self.dirty = false
    for k, v in pairs(self.targets_in_range) do
        if entity:isEnemy(v:getUserData()) then
            return v
        end
    end
    return nil
end

function Sensor:beginContact(my_fixture, their_fixture, collision)
    local other = their_fixture:getUserData()
    if other.physics.category == 3 then
        self.targets_in_range[other.uniq_id] = their_fixture
        self.dirty = true
    end
end
function Sensor:endContact(my_fixture, their_fixture, collision)
    local other = their_fixture:getUserData()
    if other.physics.category == 3 then
        self.targets_in_range[other.uniq_id] = nil
        self.dirty = true
    end
end

return Sensor
