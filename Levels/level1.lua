local level = LevelManager.levelTemplate()

function level.load()
    local game = GameManager.new()
    level.game = game

    local player = Player.new(game, V(500,300))
    level.player = player

    local enemy1 = EnemyTypes.purplegloop(game, V(100,100))
    enemy1.animation:play()

    --local enemy2 = EnemyTypes.pinkwhirl(game, V(700,300))
    --enemy2.animation:play()

    game:addEntity(player)
    game:addEntity(enemy1)
    --game:addEntity(enemy2)

    level.map = STI.new("Maps/map1")
    level.map:initWorldCollision(game:getPhysicsWorld())

    love.graphics.setBackgroundColor( 42,4,74 )
end

function level.update(dt)
    local playerX = level.player.body:getX()
    local playerY = level.player.body:getY()

    if love.keyboard.isDown('left') then
        level.player.body:setX(playerX - 4) 
    elseif love.keyboard.isDown('right') then
        level.player.body:setX(playerX + 4) 
    end

    if love.keyboard.isDown('up') then
        level.player.body:setY(playerY - 4) 
    elseif love.keyboard.isDown('down') then
        level.player.body:setY(playerY + 4)
    end
    level.game:update(dt)
end

function level.draw()
    level.map:draw()
    level.game:draw()
end

function level.keypressed(key, isRep)
end

function level.mousepressed(mx, my, button)
    -- level.player:debugBeam(mx, my)
end

return level
