require "Object"
Beam = {}
Beam.__index = Beam



Beam.setPos = Object.setPos
Beam.setVel = Object.setVel
Beam.move = Object.move
function Beam:draw()
  for i = 1, #self.points do
    love.graphics.line(self.points[i]:xy(), self.points[i+1]:xy())
  end
end

function Beam:angle()
end

function Beam:bounce(pos)
  Vector2.assert(pos)
  self.points.insert(pos)
end

function Beam:update(dt)
  self:move(dt)
end

function Beam.new()
  self = {}
  setmetatable(self, Beam)
  self.points = {}
  self:setPos(Vector2.new(50, 50))
  self:setVel(Vector2.new(0, 0))
 
  return self
end

