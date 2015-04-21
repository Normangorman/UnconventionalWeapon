V = require "lib.hump.vector"
STI = require "lib.STI"
Jumper_Grid = require "lib.Jumper.jumper.grid"
Jumper_Pathfinder = require "lib.Jumper.jumper.pathfinder"

require "lib.lovemachine.Animation.Animation"
require "lib.lovemachine.UI.Hierarchy"
require "lib.lovemachine.UI.Settings"
require "lib.lovemachine.UI.UIManager"
require "lib.lovemachine.UI.Widgets.Widget"
require "lib.lovemachine.UI.Widgets.Text"
require "lib.lovemachine.UI.Widgets.Button"

require "Beam"
require "Enemy"
require "EnemyTypes"
require "GameObject"
require "GameManager"
require "LevelManager"
require "Player"
require "Utils"

-- Work with the zerobrane debugger
if arg[#arg] == "-debug" then require("mobdebug").start() end

local NOMENU = false
PAUSED = false

HIGH_SCORE = nil

LEVEL_MANAGER = LevelManager.new()
LEVEL_MANAGER.levels["menu"] = require("Levels.menu")
LEVEL_MANAGER.levels["level1"] = require("Levels.level1")
LEVEL_MANAGER.levels["instructions"] = require("Levels.instructions")

function love.load()
    local themeMusic = love.audio.newSource("Assets/Neon Mirror Theme.wav", "stream")
    love.audio.play(themeMusic)

    if NOMENU then
        LEVEL_MANAGER:changeLevel("level1")
    else
        LEVEL_MANAGER:changeLevel("menu")
    end
end

function love.update(dt)
    if not PAUSED then
        LEVEL_MANAGER.currentLevel.update(dt)
    end
end

function love.draw()
    LEVEL_MANAGER.currentLevel.draw()
end

function love.mousepressed(mx, my, button)
    LEVEL_MANAGER.currentLevel.mousepressed(mx, my, button)
end

function love.keypressed(key, isRep)
    if key == 'p' then
        PAUSED = not PAUSED
    end

    LEVEL_MANAGER.currentLevel.keypressed(key, isRep)
end
