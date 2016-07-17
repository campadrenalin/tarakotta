require "util/extra_math"

local colors = {
    red   = { r = 255, g =  50, b =  20, a = 255 },
    green = { r =  35, g = 255, b =  20, a = 255 },
    blue  = { r =  20, g =  50, b = 255, a = 255 },
    white = { r = 255, g = 255, b = 255, a = 255 },
    black = { r =   0, g =   0, b =   0, a = 255 },
}

function colors.lerp(a, b, x)
    return {
        r = math.lerp(a.r, b.r, x),
        g = math.lerp(a.g, b.g, x),
        b = math.lerp(a.b, b.b, x),
        a = math.lerp(a.a, b.a, x),
    }
end

function colors.drawIn(c)
    love.graphics.setColor(c.r, c.g, c.b, c.a)
end

return colors
