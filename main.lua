Tower  = require "tower"
Player = require "player"
Spawn  = require "spawn"
Bullet = require "bullet"
setupCallbacks = require "callbacks"

local blue = { r =  20, g = 50, b = 255 }
local red  = { r = 255, g = 50, b =  20 }

function love.load()
    world = love.physics.newWorld(0, 0, true)
    setupCallbacks(world)

    Spawn.new(world, 200, 100, {
        name  = "1UP",
        color = blue,
        keymaps = Player.keymaps.arrows
    })
    Spawn.new(world, 100, 200, {
        name  = "2UP",
        color = red,
        keymaps = Player.keymaps.wasd
    })
    for i=1,20 do
        Tower.new(world, i*32, i*32)
    end
end

function love.draw()
    Player:drawAll()
    Tower:drawAll()
    Bullet:drawAll()
end

function love.update(dt)
    world:update(dt)

    -- Handle key events
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- Per-object updates
    Player:updateAll(dt)
    Tower:updateAll(dt)
    Bullet:updateAll(dt)
    Spawn:updateAll(dt)
end
