HC = require "lib.HardonCollider"
V = require "lib.hump.vector"

require "lib.lovemachine.Animation.Animation"

require "Beam"
require "Enemy"
require "EnemyTypes"
require "GameManager"
require "GameObject"
require "Player"
require "Utils"

-- Work with the zerobrane debugger
if arg[#arg] == "-debug" then require("mobdebug").start() end

local player
local beam
local enemy

GAME_MANAGER = GameManager.new()

function love.load()
  love.graphics.setBackgroundColor( 42,4,74 )

  player = Player.new( V(500,300) )
  beam = Beam.new(V(100,100)):setVel(V(100, 200))

  enemy1 = EnemyTypes.purplegloop(V(300,300))
  enemy1.animation:play()

  enemy2 = EnemyTypes.pinkwhirl(V(500,500))
  enemy2.animation:play()

  GAME_MANAGER:addEntity(beam)
  GAME_MANAGER:addEntity(player)
  GAME_MANAGER:addEntity(enemy1)
  GAME_MANAGER:addEntity(enemy2)

  print("love.load: initial beam.pos is " .. tostring(beam.pos))
end

function love.update(dt)
  GAME_MANAGER:update(dt)
end

function love.draw()
  GAME_MANAGER:draw()
end

function love.mousepressed(mx, my, button)
  --player:mousepressed(mx, my, button)
  beam:bounce()
  print( string.format("love.mousepressed - mx = %d, my = %d", mx, my) )
  local newVel = (V(mx, my) - beam.headPos) 
  beam.vel = newVel
end

function love.keypressed(key)
    if key == "up" then
        player.pos.y = player.pos.y - 10
    elseif key == "right" then
        player.pos.x = player.pos.x + 10 
    elseif key == "down" then
        player.pos.y = player.pos.y + 10 
    elseif key == "left" then
        player.pos.x = player.pos.x - 10 
    end
end
