local Entity = require "entities/entity"
local Wall = setmetatable({
    type = 'wall',
    physics = {
        type = 'static',
        category = 5,
    },

    behavior = 'solid',
}, Entity);
Wall.__index = Wall

function Wall:makeBody(world, p1, p2)
    self.p1 = p1
    self.p2 = p2
    return love.physics.newBody(world, 0, 0, self.physics.type)
end
function Wall:makeShape()
    return love.physics.newEdgeShape(self.p1.x, self.p1.y, self.p2.x, self.p2.y)
end
function Wall:configure(body, fixture)
    fixture:setMask(1) -- Don't bother towers
    fixture:setCategory(self.physics.category)
end

function Wall:beginContact(my_fixture, their_fixture, collision)
    if self.behavior == "murder" then
        their_fixture:getBody():destroy()
    end
end

return Wall
