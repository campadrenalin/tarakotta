local Entity = require "entities/entity"
local Wall = setmetatable({}, Entity);
Wall.__index = Wall
Wall.physics = {
    type = 'static',
    category = 5,
}

function Wall.new(level, p1, p2, type)
    local wall = Entity.new(Wall, level, 0, 0, { p1 = p1, p2 = p2 })
    wall.fixture:setMask(1) -- Don't bother towers

    return wall
end
function Wall:buildShape()
    return love.physics.newEdgeShape(self.p1.x, self.p1.y, self.p2.x, self.p2.y)
end

return Wall
