local Bullet = {}
Bullet.__index = Bullet
Bullet.registry = { nextID = 1 }

local RADIUS = 2

function Bullet.new(world, x, y)
	local bullet = setmetatable({}, Bullet)
	bullet.body    = love.physics.newBody(world, x, y, "dynamic")
	bullet.shape   = love.physics.newCircleShape(RADIUS);
	bullet.fixture = love.physics.newFixture(bullet.body, bullet.shape)

    bullet.ttl = 2

	-- Circular reference, be sure to explicitly delete
	bullet.body:setUserData(bullet)

    local r = Bullet.registry
    r[r.nextID] = bullet
    bullet.id = r.nextID
    r.nextID = r.nextID + 1

	return bullet
end

function Bullet:draw()
    if self.body == nil then
        return
    end
    love.graphics.setColor(255, 255, 255)
	love.graphics.circle("line", self.body:getX(), self.body:getY(), RADIUS, 9)
end
function Bullet:update(dt)
    if self.body == nil then
        return
    end
    self.ttl = self.ttl - dt
    if self.ttl < 0 then
        self.body:destroy()
        self.body = nil
    end
end


return Bullet
