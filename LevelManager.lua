LevelManager = {}
LevelManager.__index = LevelManager

function LevelManager.new()
    local self = {}
    setmetatable(self, LevelManager)

    self.levels = {}
    self.currentLevel = nil

    return self 
end

function LevelManager.levelTemplate()
    local temp = {}
    function temp.load()
    end
    function temp.update(dt)
    end
    function temp.draw()
    end
    function temp.mousepressed(mx, my, button)
    end
    function temp.keypressed(key, isRep)
    end
    return temp
end

function LevelManager:changeLevel( levelName )
    self.currentLevel = self.levels[levelName]
    self.currentLevel.load()
end
