require "asserts"
require "Vector2"
require "Object"
require "Player"
require "Beam"
-- Work with the zerobrane debugger
if arg[#arg] == "-debug" then require("mobdebug").start() end

local player
local beam
local V2 = Vector2.new

function love.load()
    player = Player.new()    
    player.position.x = 300
    player.position.y = 300
    player.velocity.x = 5
    player.velocity.y = 5
    
    beam = Beam.new():setPos(V2(50, 50)):setVel(V2(-1, 1))
    
end

function love.update(dt)
    player:update(dt) 
    beam:update(dt)
end

function love.draw()
    player:draw()
    beam:draw()
end
