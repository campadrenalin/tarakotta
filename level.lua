local Level = {}
Level.__index = Level
Level.current = nil

local Registry = require "util/registry"
local setupPhysicsCallbacks = require "util/callbacks"

function Level.new(path)
    local callback = require("levels/" .. path)
    local level = setmetatable({}, Level)
    level.world = love.physics.newWorld(0,0,true)
    level.registry = Registry.new()
    level.name = path
    level.title = path
    level.teams = Registry.new()

    setupPhysicsCallbacks(level.world)
    callback(level)

    love.window.setTitle('Tarakotta - ' .. level.title)
    return level
end

function Level.switchTo(path)
    if Level.current then
        Level.current:destroy()
    end
    Level.current = Level.new(path)
end

function Level:destroy()
    self.world:destroy()
end

function Level:add(class, x, y, properties)
    if type(class) == "string" then
        class = require("entities/" .. class)
    end
    return self.registry:add(
        class.new(self, x, y, properties)
    )
end
function Level:boundaries(type)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local nw = { x = 0, y = 0 }
    local sw = { x = 0, y = h }
    local ne = { x = w, y = 0 }
    local se = { x = w, y = h }

    self:add("wall", nw, ne, type)
    self:add("wall", ne, se, type)
    self:add("wall", se, sw, type)
    self:add("wall", sw, nw, type)
end
function Level:team(name, color)
    local Team = require("entities/team")
    return self.teams:add(
        Team.new(self, self.teams.nextID * 200 - 180, love.graphics.getHeight()-20, {
            name  = name,
            color = color,
        })
    )
end

function Level:draw()
    self.registry:drawAll()
    self.teams:drawAll()
    love.graphics.print(love.timer.getFPS() .. ":" .. self.registry.nextID, 0, 0)
end
function Level:update(dt)
    self.world:update(dt)
    self.registry:updateAll(dt)
    self.teams:updateAll(dt)
end

return Level
