local Player = require "entities/player"

local blue = { r =  20, g = 50, b = 255 }
local red  = { r = 255, g = 50, b =  20 }

function setup(level)
    level.title = 'Honeycomb!'
    level:boundaries("solid")

    level:add('spawn', 200, 100, {
        name  = "1UP",
        color = blue,
        keymaps = Player.keymaps.arrows
    })
    level:add('spawn', 100, 200, {
        name  = "2UP",
        color = red,
        keymaps = Player.keymaps.wasd
    })
    for row=1,10 do
        local shift = (row % 2) * 64 - 128
        for col=1,10 do
            level:add('tower', col*128 + shift, row*64 - 64)
        end
    end
end

return setup
