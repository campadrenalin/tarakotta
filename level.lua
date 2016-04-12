local Level = {}
Level.__index = Level
Level.current = nil

local setupPhysicsCallbacks = require "util/callbacks"
local Bullet = require "entities/bullet"

function Level.new(path)
    local callback = require("levels/" .. path)
    local level = setmetatable({}, Level)
    level.world = love.physics.newWorld(0,0,true)
    level.name = path
    level.title = path
    level.teams = {}

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

    properties.level = self
    local model = setmetatable(properties, class)
    local body  = model:makeBody(self.world, x, y)
    local fixture = love.physics.newFixture(body, model.shape or model:makeShape())
    fixture:setUserData(model)
    body:setUserData(model)
    model:configure(body, fixture)

    return fixture
end
function Level:boundaries(behavior)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    local nw = { x = 0, y = 0 }
    local sw = { x = 0, y = h }
    local ne = { x = w, y = 0 }
    local se = { x = w, y = h }

    self:add("wall", nw, ne, { behavior = behavior })
    self:add("wall", ne, se, { behavior = behavior })
    self:add("wall", se, sw, { behavior = behavior })
    self:add("wall", sw, nw, { behavior = behavior })
end
function Level:team(name, color)
    local Team = require("entities/team")
    local teams = self.teams
    local latest = Team.new({
        level = self,
        x = #teams * 200 + 20,
        y = love.graphics.getHeight()-20,

        name  = name,
        color = color,
    })
    teams[#teams+1] = latest
    return latest
end

function Level:draw()
    love.graphics.print(love.timer.getFPS() .. ":" .. self.world:getBodyCount(), 0, 0)
    for k, v in ipairs(self.world:getBodyList()) do
        v:getUserData():draw(v)
    end
    for k, v in ipairs(self.teams) do
        v:draw()
    end
end
function Level:update(dt)
    for k, v in ipairs(self.world:getBodyList()) do
        v:getUserData():update(v, dt)
    end
    for k, v in ipairs(self.teams) do
        v:update(dt)
    end
    self.world:update(dt)
    collectgarbage()
    print(collectgarbage("count"))
end

return Level
