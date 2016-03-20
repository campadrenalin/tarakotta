local Level = require "level"
require "util/profiler"

function love.load()
    profiler = newProfiler()
    profiler:start()
    Level.switchTo("honeycomb")
end

function love.draw()
    Level.current:draw()
end

function love.update(dt)
    Level.current:update(dt)

    -- Handle key events
    if love.keyboard.isDown("escape") then
        reportProfile()
        love.event.quit()
    end
    if love.keyboard.isDown("r") then
        Level.switchTo(Level.current.name)
    end
end

function reportProfile()
    profiler:stop()
    local outfile = io.open( "profile.txt", "w+" )
    profiler:report( outfile )
    outfile:close()
end
