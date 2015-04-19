Enemy = {}
setmetatable(Enemy, GameObject)
Enemy.__index = Enemy

function Enemy.new(pos)
  local self = GameObject.new(pos)
  setmetatable(self, Enemy)

  self.tag = "Enemy"
  self.physicsShapeType = "Circle"
  self.radius = 32

  self.color = {255,255,0}
  self.animation = nil

  return self
end

function Enemy:draw()
  love.graphics.setColor( unpack(self.color) )
  if self.animation then
    -- animation:draw assumes the position given is the top-left corner
    self.animation:draw(self.pos.x - self.radius, self.pos.y - self.radius)
  else
    love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)
  end
  love.graphics.setColor(255,255,255)
end

function Enemy:update(dt)
    print "enemy updated"
  self:move(dt)

  if self.animation then
    self.animation:update(dt)
  end
end

function Enemy:attack(player)
  local angle = self.pos:angleTo(player.pos)
end
