require "GameObject"

Enemy = {}
setmetatable(Enemy, GameObject)
Enemy.__index = Enemy

function Enemy.new(pos)
  local self = GameObject.new(pos)
  setmetatable(self, Enemy)

  self.tag = "Enemy"
  self.physicsShapeType = "Rectangle"
  self.width = 30
  self.height = 30

  self.dims = V(25, 25)
  self.color = {255,255,0}

  return self
end

function Enemy:draw()
  love.graphics.setColor( unpack(self.color) )
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.width, self.height)
  love.graphics.setColor(255,255,255)
end

function Enemy:update(dt)
    self:move(dt)
end

function Enemy:attack(player)
  local angle = self.pos:angleTo(player.pos)
end
