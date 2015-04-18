require "Beam"

Player = {}
Player.__index = Player
Player.setPos = Object.setPos
Player.setVel = Object.setVel
Player.move = Object.move
function Player.new()
  local self = {}
  setmetatable(self, Player)

  self:setPos(V(0,0))
  self:setVel(V(0,0))
  self.color = {255,255,255}
  self.dims = V(50, 50)

  return self
end




function Player:draw()
  love.graphics.setColor( unpack(self.color) )
  love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.dims.x, self.dims.y)
  love.graphics.setColor(255,255,255)
end

function Player:update(dt)
  self:move(dt)
end

function Player:mousepressed(mx, my, button)
  local mouseVector = V(mx, my)
  local angle = self.pos:angleTo(mouseVector) 
  local beam = Beam.new(self.position, angle)
end
