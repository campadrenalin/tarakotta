function establish(world)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function getEntity(fixture)
    return fixture:getUserData()
end

-- Called when two fixtures begin to overlap.
function beginContact(a,b,col)
    local ea = getEntity(a)
    local eb = getEntity(b)
    ea:beginContact(a, b, col)
    eb:beginContact(b, a, col)
end

-- Called when two fixtures cease to overlap.
-- This will also be called outside of a world update, when colliding objects are destroyed.
function endContact(a,b,col)
    local ea = getEntity(a)
    local eb = getEntity(b)
    ea:endContact(a, b, col)
    eb:endContact(b, a, col)
end

-- Gets called before a collision gets resolved.
function preSolve(a,b,col)
end

-- Gets called after the collision has been resolved.
-- NI = Normal  Impulse
-- TI = Tangent Impulse
function postSolve(a,b,col, NI1, TI1, NI2, TI2)
end

return establish
