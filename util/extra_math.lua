-- https://love2d.org/wiki/General_math

-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

-- Returns the angle between two points.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

-- Linear interpolation between two numbers.
function math.lerp(a,b,t) return a+(b-a)*t end
