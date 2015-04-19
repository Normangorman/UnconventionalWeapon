-- All level manager does is load these level files, which are 
-- effectively a load of different main.lua files, and overwrite its
-- callbacks with the callbacks from the level. If you switch between 
-- level 2 to level 3 and then back to level 2, all the original state 
-- from level 2 is lost, as the load function gets rerun.  

LEVEL_MANAGER = {}
LEVEL_MANAGER.levels = {}
LEVEL_MANAGER.levels["menu"] = require "Levels.menu"
LEVEL_MANAGER.levels[1] =  require "Levels.1"

function LEVEL_MANAGER.changeLevel(n)
  for k, v in pairs(LEVEL_MANAGER.levels[n]) do
    LEVEL_MANAGER[k] = LEVEL_MANAGER.levels[n][k]
  end
  LEVEL_MANAGER.load()
end

function LEVEL_MANAGER.levelTemplate()
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




