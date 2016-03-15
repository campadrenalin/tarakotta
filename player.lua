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

function Player.new(world, x, y)
    local player = Entity.new(Player, world, x, y, RADIUS, "dynamic")
    player.fixture:setRestitution(0.7)
    player.body:setLinearDamping(DAMP)
    return player
end

function Player:draw()
    self:drawCircle(RADIUS, 20,   20, 80, 255)
end

function Player:update()
    self:readKeys(Player.keymaps.arrows)
    self:readKeys(Player.keymaps.wasd)
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
