local Level = {}
Level.__index = Level
Level.current = nil

-- local Registry = require "util/registry"
local setupPhysicsCallbacks = require "util/callbacks"
local Bullet = require "entities/bullet"

function Level.new(path)
    local callback = require("levels/" .. path)
    local level = setmetatable({}, Level)
    level.world = love.physics.newWorld(0,0,true)
    -- level.registry = Registry.new()
    level.name = path
    level.title = path
    -- level.teams = Registry.new()

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

    local model = setmetatable(properties, class)
    local body  = model:makeBody(self.world, x, y)
    local fixture = love.physics.newFixture(body, model.shape or model:buildShape())
    fixture:setUserData(model)
    body:setUserData(model)

    return fixture
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
        Team.new(self, self.teams.size * 200 + 20, love.graphics.getHeight()-20, {
            name  = name,
            color = color,
        })
    )
end

function Level:draw()
    love.graphics.print(love.timer.getFPS() .. ":" .. self.world:getBodyCount(), 0, 0)
    for k, v in ipairs(self.world:getBodyList()) do
        v:getUserData():draw(v)
    end
end
function Level:update(dt)
    for i=0,10 do
        local fixture = self:add(Bullet, math.random(200, 400), math.random(200, 400), {})
        fixture:getUserData():fireRandom(fixture:getBody())
    end
    for k, v in ipairs(self.world:getBodyList()) do
        v:getUserData():update(v, dt)
    end
    self.world:update(dt)
    collectgarbage()
    print(collectgarbage("count"))
end

return Level
