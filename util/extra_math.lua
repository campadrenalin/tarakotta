-- https://love2d.org/wiki/General_math

-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
function math.object_dist(obj1, obj2)
    local x1, y1 = obj1.body:getPosition()
    local x2, y2 = obj2.body:getPosition()
    return math.dist(x1,y1, x2,y2)
end

-- Returns the angle between two points.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end
function math.object_angle(obj1, obj2)
    local x1, y1 = obj1.body:getPosition()
    local x2, y2 = obj2.body:getPosition()
    return math.angle(x1,y1, x2,y2)
end

function math.vector_xy(angle, dist)
    return dist*math.cos(angle), dist*math.sin(angle)
end

-- Linear interpolation between two numbers.
function math.lerp(a,b,t) return a+(b-a)*t end
