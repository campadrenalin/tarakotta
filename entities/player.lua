local MAX_HEALTH = 100
local FORCE  = 80
local DAMP   = 2.3
local SMOOTH = 10
local DAMAGE_COLOR = { r = 255, g = 255, b = 255 }
local RECOVER_TIME = 3 -- in seconds

local Entity = require "entities/entity"
local Player = setmetatable({
    type = 'player',
    physics = {
        type = 'dynamic',
        category = 3,
        radius = 4,
    },

    hp = MAX_HEALTH,
}, Entity);
Player.__index = Player

local KeyboardInput = require "input/keyboard"
require "util/extra_math"

function Player:configure(body, fixture)
    fixture:setRestitution(0.7)
    body:setLinearDamping(DAMP)
    if self.team then
        self.name = self.name  or self.team.name
    end
    self.input = self.input or KeyboardInput.new(self.keymap)
end

function Player:draw(body)
    self.input:draw()
    self:drawCircle(body, nil, 20)

    if self.hp < MAX_HEALTH then
        local fill_radius = math.lerp(self.physics.radius, 0, self.hp/MAX_HEALTH)
        self:drawCircle(body, fill_radius, 20, DAMAGE_COLOR, "fill")
    end
end

function Player:_destroy()
    for i=1,30 do
        self:make('bullet', self.body:getX(), self.body:getY(), { team = self.team })
    end
    Entity._destroy(self)
end

function Player:update(body, dt)
    self:inputMotion(body, dt)
    self:heal(dt)
end

function Player:inputMotion(body, dt)
    local i = self.input
    i:update(dt, self)
    local fx = i:value("left", -FORCE,
        i:value("right", FORCE, 0))
    local fy = i:value("up", -FORCE,
        i:value("down", FORCE, 0))
    -- TODO: Compensate for "diagonal boost"

    local vx, vy = body:getLinearVelocity()
    body:applyForce(fx, fy) -- Raw force
    body:applyForce((fx-vx)/SMOOTH, (fy-vy)/SMOOTH) -- For agility: (speed_wanted - speed_have)/SMOOTH
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
