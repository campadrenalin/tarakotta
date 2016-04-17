local Player = require "entities/player"
local colors = require 'util/colors'

function setup(level)
    level:boundaries("murder")

    level:team('1UP', colors.blue):spawn(200, 100, {
        keymap = 'arrows',
    })
    level:team('2UP', colors.red):spawn(100, 200, {
        keymap = 'wasd',
    })
    for i=1,20 do
        level:add('tower', i*32, i*32, {})
    end
end

return setup
