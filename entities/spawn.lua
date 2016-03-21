local Spawn = {}
Spawn.__index = Spawn

local Player   = require "entities/player"
local Registry = require "util/registry"

function Spawn.new(level, x, y, spec)
    local spawn = setmetatable({}, Spawn)
    spawn.level = level
    spawn.coordinates = { x = x, y = y }
    spawn.spec = spec
    spawn.player = nil

    return spawn
end

function Spawn:respawn()
    local c = self.coordinates
    local s = self.spec
    self.player = Player.new(
        self.level,
        c.x, c.y,
        s.name, s.color, s.keymaps)
    self.player.spawn = self
end

function Spawn:draw() end
function Spawn:update(dt)
    if self.player == nil or self.player.destroyed then
        self:respawn()
    end
end

return Spawn
