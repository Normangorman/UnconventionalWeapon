require "Player"

local player

function love.load()
    player = Player.new()    
    player.position.x = 300
    player.position.y = 300
    player.velocity.x = 5
    player.velocity.y = 5
end

function love.update(dt)
    player:update(dt) 
end

function love.draw()
    player:draw()
end
