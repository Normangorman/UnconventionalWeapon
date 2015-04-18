require "asserts"
V = require "lib.hump.vector"
require "Player"
require "Beam"
require "Enemy"
require "GameManager"

-- Work with the zerobrane debugger
if arg[#arg] == "-debug" then require("mobdebug").start() end

local player
local beam
local enemy

GAME_MANAGER = GameManager.new(HC)

function love.load()
<<<<<<< HEAD
  player = Player.new( V(300,300) )
  beam = Beam.new(V(100,100)):setVel(V(100, 200))
  enemy = Enemy.new(V(200,200)):setVel(V(-5, 5))

  GAME_MANAGER:addEntity(beam)
  GAME_MANAGER:addEntity(player)
  GAME_MANAGER:addEntity(enemy)

  print("love.load: initial beam.pos is " .. tostring(beam.pos))
end

function love.update(dt)
  GAME_MANAGER:update(dt)
end

function love.draw()
  GAME_MANAGER:draw()
=======
  player = Player.new(): setPos(V(50, 50)):setVel(V(5, 5))
  beam = Beam.new():setPos(V(50, 50)):setVel(V(20, 10))
  print(beam.pos)
  beam:bounce(beam.pos)
end

timer = 2
function love.update(dt)
  print(dt)
  timer = timer - dt
  if timer < 0 then
    beam:bounce(beam.pos)
    beam:setVel(V(50, 60))
  end
  
 player:update(dt) 
  beam:update(dt)
  --GAME_MANAGER.update(dt)
end

function love.draw()
  player:draw()
  beam:draw()
 -- GAME_MANAGER.draw()
>>>>>>> 4e9bfc621cb5c5c3cea95bbc30a9b4618d91cca0
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
