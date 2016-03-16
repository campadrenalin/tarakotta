Tower  = require "tower"
Player = require "player"
Bullet = require "bullet"
setupCallbacks = require "callbacks"

local blue = {
    red   = 20,
    green = 50,
    blue  = 255
}
local red = {
    red   = 255,
    green = 50,
    blue  = 20
}


function love.load()
    world = love.physics.newWorld(0, 0, true)
    setupCallbacks(world)

    Player.new(world, 200, 100, "1UP", blue, Player.keymaps.arrows)
    Player.new(world, 100, 200, "2UP", red,  Player.keymaps.wasd)
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
end
