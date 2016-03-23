local Entity = require "entities/entity"
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
Player.physics = {
    type = 'dynamic',
    category = 3,
    radius = 4,
}

require "util/extra_math"

local FORCE  = 80
local DAMP   = 2.3
local SMOOTH = 10
local DAMAGE_COLOR = { r = 255, g = 255, b = 255 }
local MAX_HEALTH   = 100
local RECOVER_TIME = 3 -- in seconds

function Player.new(level, x, y, properties)
    local player = Entity.new(Player, level, x, y, properties)
    player.fixture:setRestitution(0.7)
    player.body:setLinearDamping(DAMP)

    player.hp   = MAX_HEALTH
    player.name = player.name or player.team.name
    return player
end

function Player:draw()
    self:drawCircle(self.physics.radius, 20)

    if self.hp < MAX_HEALTH then
        local fill_radius = math.lerp(self.physics.radius, 0, self.hp/MAX_HEALTH)
        self:drawCircle(fill_radius, 20, DAMAGE_COLOR, "fill")
    end
end

function Player:update(dt)
    self:readKeys(self.keymap)

    -- Auto-healing
    self.hp = self.hp + (dt * MAX_HEALTH / RECOVER_TIME)
    if self.hp > MAX_HEALTH then
        self.hp = MAX_HEALTH
    end
end
function Player:beginContact(other, collision)
    if other.physics.category == 2 and self:isEnemy(other) then -- bullet
        local vx, vy = other.body:getLinearVelocity()
        local speed = math.dist(0,0,vx,vy)
        self.hp = self.hp - speed/20
        if self.hp < 0 then
            self:destroy()
        end

        other:destroy()
        return
    end
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
