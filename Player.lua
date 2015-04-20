Player = {}
setmetatable(Player, GameObject)
Player.__index = Player

function Player.new(pos)
  local self = GameObject.new(pos)
  setmetatable(self, Player)

  self.tag = "Player"
  self.physicsShapeType = "Circle"
  self.radius = 30

  self.color = {255,255,255}

  return self
end

function Player:draw()
  love.graphics.setColor( unpack(self.color) )
  love.graphics.circle("fill", self.pos.x, self.pos.y, self.radius)
  love.graphics.setColor(255,255,255)
end

function Player:update(dt)
  self:move(dt)
end

function Player:mousepressed(mx, my, button)
  -- local mouseVector = V(mx, my)
  -- local angle = self.pos:angleTo(mouseVector) 
  -- local beam = Beam.new(self.position, angle)

  -- GAME_MANAGER:addEntity(beam)
end
