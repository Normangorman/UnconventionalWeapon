require "asserts"
V = require "lib/hump/vector"
require "Object"
require "Player"
require "Beam"
--require "GameManager"

-- Work with the zerobrane debugger
if arg[#arg] == "-debug" then require("mobdebug").start() end

local player

--GAME_MANAGER = GameManager.new()

function love.load()
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
end


function love.mousepressed(button, mx, my)
  --player:mousepressed(button, mx, my)
 -- player = Player.new()    
 -- player.pos.x = 300
 -- player.pos.y = 300
  --GAME_MANAGER:addEntity(player)
end