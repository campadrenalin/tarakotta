local Level = require "level"

function love.load()
    Level.switchTo("demo")
end

function love.draw()
    Level.current:draw()
end

function love.update(dt)
    Level.current:update(dt)

    -- Handle key events
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if love.keyboard.isDown("r") then
        Level.switchTo(Level.current.name)
    end
end
