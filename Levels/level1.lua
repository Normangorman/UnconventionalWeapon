local level = LevelManager.levelTemplate()

function level.load()
    local game = GameManager.new()
    level.game = game
end

function level.update(dt)
    level.game:update(dt)
end

function level.draw()
    level.game:draw()
end

function level.keypressed(key, isRep)
    level.game:keypressed(key, isRep)
end

function level.mousepressed(mx, my, button)
    level.game:mousepressed(mx, my, button)
end

return level
