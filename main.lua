require "Player"

local player

function love.load()
    player = Player.new()    
    player.x = 300
    player.y = 300
    player.vx = 5
    player.vy = 5

    for k, v in pairs(player) do
        print(k,v)
    end
end

function love.update(dt)
    player:update(dt) 
end

function love.draw()
    player:draw()
end
