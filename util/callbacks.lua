function establish(world)
    world:setCallbacks(beginContact, endContact, preSolve, postSolve)
end

function getEntity(fixture)
    return fixture:getBody():getUserData()
end

-- Called when two fixtures begin to overlap.
function beginContact(a,b,col)
    local a = getEntity(a)
    local b = getEntity(b)
    a:beginContact(b, col)
    b:beginContact(a, col)
end

-- Called when two fixtures cease to overlap.
-- This will also be called outside of a world update, when colliding objects are destroyed.
function endContact(a,b,col)
    local a = getEntity(a)
    local b = getEntity(b)
    a:endContact(b, col)
    b:endContact(a, col)
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
