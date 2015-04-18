GameManager = {}
GameManager.__index = GameManager

function GameManager.new()
  local self = {}
  setmetatable(self, GameManager)

  self.entities = {}

  return self 
end

function GameManager:update(dt)
  for _, e in ipairs(self.entities) do
    e:update(dt)
  end
end

function GameManager:draw()
  for _, e in ipairs(self.entities) do
    e:draw()
  end
end

function GameManager:addEntity(e)
  table.insert(self.entities, e)
end

