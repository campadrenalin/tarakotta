local Entity = require "entities/entity"
local Spawn = setmetatable({}, Entity)
Spawn.__index = Spawn
Spawn.MAX_COOLDOWN = 0.4

local Player   = require "entities/player"
local Registry = require "util/registry"

function Spawn.new(level, x, y, spec)
    local spawn = setmetatable({}, Spawn)
    spawn.level = level
    spawn.coordinates = { x = x, y = y }
    spawn.spec = spec
    spawn.player = nil
    spawn.cooldown = 0

    return spawn
end

function Spawn:respawn()
    local c = self.coordinates
    local s = self.spec
    self.cooldown = self.MAX_COOLDOWN
    self.player = self:make(Player, c.x, c.y, s)
end

function Spawn:draw() end
function Spawn:update(dt)
    if self.player == nil or self.player.destroyed then
        if self.cooldown > 0 then
            self.cooldown = self.cooldown - dt
        else
            self:respawn()
        end
    end
end

return Spawn
