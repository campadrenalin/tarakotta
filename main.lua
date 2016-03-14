Tower  = require "tower"
Player = require "player"
Bullet = require "bullet"

function love.load()
    world = love.physics.newWorld(0, 0, true)
    -- world:setCallbacks

    Player.new(world, 100, 200)
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
