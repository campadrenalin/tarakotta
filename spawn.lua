local Spawn = {}
Spawn.__index = Spawn

local Player   = require "player"
local Registry = require "registry"
Spawn.registry = Registry.new()

function Spawn.new(world, x, y, spec)
    local spawn = setmetatable({}, Spawn)
    spawn.world = world
    spawn.coordinates = { x = x, y = y }
    spawn.spec = spec
    spawn.player = nil
    spawn.registry:add(spawn)

    return spawn
end

function Spawn:respawn()
    local c = self.coordinates
    local s = self.spec
    self.player = Player.new(
        self.world,
        c.x, c.y,
        s.name, s.color, s.keymaps)
    self.player.spawn = self
end

function Spawn:update()
    if self.player == nil or self.player.destroyed then
        self:respawn()
    end
end

function Spawn:drawAll() end
function Spawn:updateAll(dt) Spawn.registry:updateAll(dt) end

return Spawn
