local Entity = require "entities/entity"
local Player = setmetatable({}, Entity);
Player.__index = Player
Player.type = 'player'
Player.physics = {
    type = 'dynamic',
    category = 3,
    radius = 4,
}

local KeyboardInput = require "input/keyboard"
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

    player.hp    = MAX_HEALTH
    player.name  = player.name  or player.team.name
    player.input = player.input or KeyboardInput.new(player.keymap)
    return player
end

function Player:draw()
    self.input:draw()
    self:drawCircle(self.physics.radius, 20)

    if self.hp < MAX_HEALTH then
        local fill_radius = math.lerp(self.physics.radius, 0, self.hp/MAX_HEALTH)
        self:drawCircle(fill_radius, 20, DAMAGE_COLOR, "fill")
    end
end

function Player:_destroy()
    for i=1,30 do
        self:make('bullet', self.body:getX(), self.body:getY(), { team = self.team })
    end
    Entity._destroy(self)
end

function Player:update(dt)
    self:inputMotion(dt)
    self:heal(dt)
end

function Player:inputMotion(dt)
    local i = self.input
    i:update(dt, self)
    local fx = i:value("left", -FORCE,
        i:value("right", FORCE, 0))
    local fy = i:value("up", -FORCE,
        i:value("down", FORCE, 0))
    -- TODO: Compensate for "diagonal boost"

    local vx, vy = self.body:getLinearVelocity()
    self.body:applyForce(fx, fy) -- Raw force
    self.body:applyForce((fx-vx)/SMOOTH, (fy-vy)/SMOOTH) -- For agility: (speed_wanted - speed_have)/SMOOTH
end

function Player:heal(dt)
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

return Player
