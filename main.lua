local Level = require "level"
local cmdline_args = rawget(_G, "arg") or {}
for _, arg in ipairs(cmdline_args) do
    cmdline_args[arg] = 1
end

function love.load()
    startProfile()
    Level.switchTo("leak")
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

function startProfile()
    if not cmdline_args.profile then return end

    require "util/profiler"
    profiler = newProfiler()
    profiler:start()
end
function reportProfile()
    if not cmdline_args.profile then return end

    profiler:stop()
    local outfile = io.open( "profile.txt", "w+" )
    profiler:report( outfile )
    outfile:close()
end
