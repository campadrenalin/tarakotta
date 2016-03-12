Tower = require "tower"
towers = {}

Player = require "player"
Bullet = require "bullet"

function love.load()
	world = love.physics.newWorld(0, 0, true)
	-- world:setCallbacks
	
	player = Player.new(world, 100, 200)
	for i=1,20 do
		towers[i] = Tower.new(world, i*32, i*32)
	end
end

function love.draw()
	player:draw()
	Tower:drawAll()
	Bullet:drawAll()
end

function love.update(dt)
	world:update(dt)

	-- Handle key events
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	player:readKeys(Player.keymaps.arrows)
	player:readKeys(Player.keymaps.wasd)

	-- Per-object updates
	Tower:updateAll(dt)
	Bullet:updateAll(dt)
end
