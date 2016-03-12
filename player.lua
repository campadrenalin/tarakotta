local Entity = require "entity"
local Player = setmetatable({}, Entity);
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
	local player = Entity.new(Player, world, x, y, RADIUS, "dynamic")
	return player
end

function Player:draw()
    self:drawCircle(RADIUS, 20,   20, 80, 255)
end

function Player:update()
    self:readKeys(Player.keymaps.arrows)
    self:readKeys(Player.keymaps.wasd)
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
