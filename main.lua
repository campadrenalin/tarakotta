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

function drawArray(array)
	for i=1,table.getn(array) do
		array[i]:draw()
	end
end
function updateArray(array, dt)
	for i=1,table.getn(array) do
		array[i]:update(dt)
	end
end

function love.draw()
	player:draw()
	drawArray(towers)
	drawArray(Bullet.registry)
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
    updateArray(towers, dt)
    updateArray(Bullet.registry, dt)
end
