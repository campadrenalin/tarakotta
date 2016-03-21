local Player = require "entities/player"

local blue = { r =  20, g = 50, b = 255, name = 'blue' }
local red  = { r = 255, g = 50, b =  20, name = 'red'  }

function setup(level)
    level:boundaries("murder")

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
    for i=1,20 do
        level:add('tower', i*32, i*32)
    end
end

return setup
