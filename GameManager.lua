GameManager = {}
GameManager.__index = GameManager

function GameManager.new()
  local self = {}
  setmetatable(self, GameManager)

  return self 
end
