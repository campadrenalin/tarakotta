local Entity = require "entities/entity"
local Spawn = setmetatable({
    type = 'spawn',
    MAX_COOLDOWN = 0.4,

    player = nil,
    cooldown = 0,
    physics = {
        type = 'static',
        radius = 20,
    },
}, Entity)
Spawn.__index = Spawn

function Spawn:configure(body, fixture)
    fixture:setSensor(true)
end

function Spawn:respawn(body)
    local x, y = body:getPosition()
    self.cooldown = self.MAX_COOLDOWN
    self.player = self.level:add("player", x, y, {
        team   = self.team,
        keymap = self.keymap,
        input  = self.input,
    })
end

function Spawn:draw(body) end
function Spawn:update(body, dt)
    if self.player == nil or self.player.destroyed then
        if self.cooldown > 0 then
            self.cooldown = self.cooldown - dt
        else
            self:respawn(body)
        end
    end
end

return Spawn
