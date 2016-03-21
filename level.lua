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
    local entity = class.new(self, x, y, properties)
    self.registry:add(entity)
    return entity
end

function Level:draw()
    self.registry:drawAll()
end
function Level:update(dt)
    self.world:update(dt)
    self.registry:updateAll(dt)
end

return Level
