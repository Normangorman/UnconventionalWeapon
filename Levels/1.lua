local level = LEVEL_MANAGER.levelTemplate()
local player
local beam
local enemy
local map

function level.load()
  GAME_MANAGER = require("GameManager").new()
  love.graphics.setBackgroundColor( 42,4,74 )

  player = Player.new( V(500,300) )
  beam = Beam.new(V(100,100)):setVel(V(100, 200))

  enemy1 = EnemyTypes.purplegloop(V(300,300))
  enemy1.animation:play()

  enemy2 = EnemyTypes.pinkwhirl(V(700,300))
  enemy2.animation:play()

  GAME_MANAGER:addEntity(beam)
  GAME_MANAGER:addEntity(player)
  GAME_MANAGER:addEntity(enemy1)
  GAME_MANAGER:addEntity(enemy2)

  map = STI.new("Maps/map1")
  -- Add all the tiles to the physics world
  print("Printing map.layers[1].data[1][1]:")
  for k,v in pairs(map.layers[1].data[1][1]) do
    print(k,v)
  end

  for y=1, map.height do
      for x=1, map.width do
          if map.layers[1].data[y][x] ~= nil then

              local tile = GameObject.new(V((x-1)*32 + 16, (y-1)*32 + 16))
              tile.physicsShapeType = "Rectangle"

              -- One pixel smaller than they should be so the physics engine doesn't collide them all the time
              tile.width = 32
              tile.height = 32

              GAME_MANAGER:addEntity(tile, "foreground_tiles")
          end
      end
  end
end

function level.update(dt)
  print("map: " .. type(map))
  GAME_MANAGER:update(dt)
  map:update(dt)
end

function level.draw()
  GAME_MANAGER:draw()
  map:draw()
end

function level.keypressed(key, isRep)
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

function level.mousepressed(mx, my, button)
  beam:bounce()
  print( string.format("love.mousepressed - mx = %d, my = %d", mx, my) )
  local newVel = (V(mx, my) - beam.headPos) 
  beam.vel = newVel
end

return level
