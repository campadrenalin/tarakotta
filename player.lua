local Entity = require "entity"
local Player = setmetatable({}, Entity);
Player.__index = Player
Player.keymaps = {
    arrows = {
        up    = "up",
        down  = "down",
        left  = "left",
        right = "right",
    },
    wasd = {
        w = "up",
        s = "down",
        a = "left",
        d = "right",
    },
}
Player.physics_category = 3

local RADIUS = 4
local FORCE  = 80
local DAMP   = 2.3
local SMOOTH = 10

-- TODO: Limited HP
function Player.new(world, x, y, name, color, keymap)
    local player = Entity.new(Player, world, x, y, RADIUS, "dynamic")
    player.fixture:setRestitution(0.7)
    player.body:setLinearDamping(DAMP)

    player.name   = name
    player.color  = color
    player.keymap = keymap
    return player
end

function Player:draw()
    local c = self.color
    self:drawCircle(RADIUS, 20,   c.red, c.green, c.blue)
end

function Player:update()
    self:readKeys(self.keymap)
end

function Player:readKeys(map)
    for k, v in pairs(map) do
        if love.keyboard.isDown(k) then
            self:_keypress(v)
        end
    end
end
function Player:keyforce(x, y)
    local vx, vy = self.body:getLinearVelocity()
    self.body:applyForce(x, y) -- Raw force
    self.body:applyForce((x-vx)/SMOOTH, (y-vy)/SMOOTH) -- For agility: (speed_wanted - speed_have)/SMOOTH
end
function Player:_keypress(key)
    if key == "up" then
        self:keyforce(0, -FORCE)
    elseif key == "down" then
        self:keyforce(0, FORCE)
    elseif key == "left" then
        self:keyforce(-FORCE, 0)
    elseif key == "right" then
        self:keyforce(FORCE,  0)
    end
end

return Player
