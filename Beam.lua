require "Utils"
require "GameObject"

Beam = {}
setmetatable(Beam, GameObject)
Beam.__index = Beam

function Beam.new(initialPos)
  local self = GameObject.new(initialPos)
  setmetatable(self, Beam)

  self.tag = "Beam"
  self.physicsShapeType = "Point"

  self.points = {initialPos}
  self.headPos = Utils.copy(initialPos)
  self.tailPos = Utils.copy(initialPos)
  -- The index of the point in the points array which the tail is ahead of.
  self.tailIndex = 1

  -- self.pos is not used internally but is exposed externally so that a beam obeys the same interface
  -- as other game objects.
  self.pos = self.headPos

  self.color = {100, 150, 100}

  return self
end

function Beam:update(dt)
  self.headPos = self.headPos + self.vel * dt

  -- Only move the tail if the length of the beam exceeds some threshold amount. Here it's 250.
  if self:getLength() > 250 then
    local vel_magnitude = self.vel:len() * dt

    -- Calculate the velocity that the tail needs to travel at.
    local tailDestination = self.points[self.tailIndex + 1] or self.headPos

    local destinationVec = tailDestination - self.tailPos
    local destinationAngle = V(0,0):angleTo(destinationVec)
    local vx = math.cos(destinationAngle) * vel_magnitude
    local vy = -(math.sin(destinationAngle) * vel_magnitude)
    local tailVel = V(vx, vy)

    -- If the magnitude of this velocity is greater than the magnitude of the distance to the tail's
    -- destination, then increase tailIndex by 1 (i.e. it has gone past the destination).
    if tailVel:len() > destinationVec:len() then
        self.tailPos = Utils.copy(tailDestination)
        self.tailIndex = self.tailIndex + 1
    else
        self.tailPos = self.tailPos + tailVel
    end
  end

  self.pos = self.headPos
end

function Beam:draw()
  love.graphics.setColor( unpack(self.color) )

  -- Connect all the points in the stack
  local points = self:getActivePoints()

  for i=1, #points-1 do
    love.graphics.line(points[i].x, points[i].y, points[i+1].x, points[i+1].y)
  end

  love.graphics.setColor(255,255,255)
end

-- Returns the tail, the head and all points in between.
function Beam:getActivePoints() 
  local points = Utils.copy(self.points)

  -- Drop all points before the tail.
  for i=1, self.tailIndex do
      table.remove(points, 1)
  end
  -- Insert the tail at the bottom of the stack.
  table.insert(points, 1, self.tailPos)
  -- Insert the head at the top of the stack.
  table.insert(points, self.headPos)

  return points
end

function Beam:getLength()
  local points = self:getActivePoints()
  local length = 0
  for i=1, #points-1 do
      length = length + (points[i+1] - points[i]):len()
  end

  return length
end

function Beam:bounce()
  table.insert(self.points, self.headPos)
  local newPos = Utils.copy(self.headPos)
  self.headPos = newPos
end

function Beam:collisionStart(other, dt, mtv_x, mtv_y)
  
end
