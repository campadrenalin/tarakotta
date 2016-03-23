local Player = require "entities/player"

local blue = { r =  20, g = 50, b = 255 }
local red  = { r = 255, g = 50, b =  20 }

function setup(level)
    level:boundaries("murder")

    level:team('1UP', blue):spawn(200, 100, {
        keymaps = Player.keymaps.arrows,
    })
    level:team('2UP', red):spawn(100, 200, {
        keymaps = Player.keymaps.wasd,
    })
    for i=1,20 do
        level:add('tower', i*32, i*32)
    end
end

return setup
