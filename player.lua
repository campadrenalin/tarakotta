Player = {}
Player.__index = Player
Player.keymaps = {
	arrows = {
		up    = "up",
		down  = "down",
		left  = "left",
		right = "right",
	},
	wasd = {
		w = "up",
		s = "down",
		a = "left",
		d = "right",
	},
}

local RADIUS = 4

function Player.new(world, x, y)
	local player = setmetatable({}, Player)
	player.body    = love.physics.newBody(world, x, y, "dynamic")
	player.shape   = love.physics.newCircleShape(RADIUS);
	player.fixture = love.physics.newFixture(player.body, player.shape)

	-- Circular reference, be sure to explicitly delete
	player.body:setUserData(player)

	return player
end

function Player:draw()
	love.graphics.circle("line", self.body:getX(), self.body:getY(), RADIUS, 20)
end

function Player:readKeys(map)
	for k, v in pairs(map) do
		if love.keyboard.isDown(k) then
			self:_keypress(v)
		end
	end
end

function Player:_keypress(key)
	if key == "up" then
		self.body:applyForce(0, -20)
	elseif key == "down" then
		self.body:applyForce(0, 20)
	elseif key == "left" then
		self.body:applyForce(-20, 0)
	elseif key == "right" then
		self.body:applyForce(20,  0)
	end
end

return Player
