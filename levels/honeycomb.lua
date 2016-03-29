local Player = require "entities/player"
local colors = require 'util/colors'

function setup(level)
    level.title = 'Honeycomb!'
    level:boundaries("solid")

    level:team('1UP', colors.blue):spawn(200, 100, {
        keymap = 'arrows',
    })
    level:team('2UP', colors.red):spawn(100, 200, {
        keymap = 'wasd',
    })
    for row=1,10 do
        local shift = (row % 2) * 64 - 128
        for col=1,10 do
            level:add('tower', col*128 + shift, row*64 - 64)
        end
    end
end

return setup
