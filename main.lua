require "Object"
require "Vector2"
require "Player"
require "GameManager"

local player

GAME_MANAGER = GameManager.new()

function love.load()
  player = Player.new()    
  player.position.x = 300
  player.position.y = 300

  GAME_MANAGER:addEntity(player)
end

function love.update(dt)
  GAME_MANAGER:update(dt)
end

function love.draw()
  GAME_MANAGER:draw()
end

function love.mousepressed(mx, my, button)
  player:mousepressed(mx, my, button)
end
