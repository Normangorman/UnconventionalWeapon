require "Object"
Beam = {}
Beam.__index = Beam

Beam.setPos = Object.setPos
Beam.setVel = Object.setVel

function Beam.new(position, velocity)
  self = {}
  setmetatable(self, Beam)

  self.latestPoint = position
  local basePoint = Vector2.new(position.x, position.y)
  self.points = {basePoint, self.latestPoint}
  self.velocity = velocity or Vector2.new(0,0) 
  self.color = {125,125,0}
 
  return self
end

function Beam:update(dt)
  self:move(dt)
end

Beam.setPos = Object.setPos
Beam.setVel = Object.setVel
Beam.move = Object.move

function Beam:draw()
  love.graphics.setColor( unpack(self.color) )
  for i = 1, #self.points do
    love.graphics.line(self.points[i]:xy(), self.points[i+1]:xy())
  end
  love.graphics.setColor(255,255,255)
end

function Beam:move(dt)
  local magnitude = self.velocity:magnitude()
  local angle = self.velocity:getAngle()

  local delta = Vector2.new(math.cos(angle) * magnitude, math.sin(angle) * magnitude)

  self.latestPoint = self.latestPoint + delta 
end

function Beam.new()
  self = {}
  setmetatable(self, Beam)
  self.points = {}
  self:setPos(Vector2.new(50, 50))
  self:setVel(Vector2.new(0, 0))
 
  return self
end

function Beam:bounce(pos)
  Vector2.assert(pos)
  self.points.insert(pos)
end
