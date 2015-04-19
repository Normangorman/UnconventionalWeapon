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

  self.points = Utils.stack()

  self.headPos = Utils.copy(initialPos)
  self.tailPos = Utils.copy(initialPos)

  -- self.pos is not used internally but is exposed externally so that a beam obeys the same interface
  -- as other game objects.
  self.pos = self.headPos

  self.color = {100, 150, 100}

  return self
end

function Beam:update(dt)
  self.headPos = self.headPos + self.vel * dt

  -- Only move the tail if the length of the beam exceeds some threshold amount. Here it's 250.
  if self:getLength() > 40 then
    local vel_magnitude = self.vel:len() * dt

    -- Calculate the velocity that the tail needs to travel at.
    local tailDestination = self.points[1] or self.headPos

    local destinationVec = tailDestination - self.tailPos
    local destinationAngle = V(0,0):angleTo(destinationVec)
    local vx = math.cos(destinationAngle) * vel_magnitude
    local vy = -(math.sin(destinationAngle) * vel_magnitude)
    local tailVel = V(vx, vy)

    -- If the magnitude of this velocity is greater than the magnitude of the distance to the tail's
    -- destination, then increase tailIndex by 1 (i.e. it has gone past the destination).
    if tailVel:len() > destinationVec:len() then
        self.tailPos = tailDestination
        self.points:popBase()
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

  points:pushBase(self.tailPos)
  points:push(self.headPos)

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
  print(string.format("Beam:collisionStart called with mtv_x=%f, mtv_y = %f", mtv_x, mtv_y))
  if other.physicsShapeType == "Rectangle" then
    local delta = self.pos - other.pos

    print("Other object is a Rectangle")
    print(string.format("delta.x = %f, delta.y = %f", delta.x, delta.y))
    local side = ""
    if delta.y <= 0 then -- the beam is above the center of the rect
        if math.abs(delta.y) >= math.abs(delta.x) then
          side = "top"
        elseif delta.x >= 0 then
          side = "right"
        else
          side = "left"
        end
    else -- the beam is below the center of the rect
        if math.abs(delta.y) <= math.abs(delta.x) then
          side = "bottom"
        elseif delta.x >= 0 then
          side = "right"
        else
          side = "left"
        end
    end

    print(string.format("Calculated nearest side to be %s", side))
    if side == "top" or side == "bottom" then
      self.vel.y = self.vel.y * -1
    else
      self.vel.x = self.vel.x * -1
    end
    self.headPos.x = self.headPos.x + mtv_x
    self.headPos.y = self.headPos.y + mtv_y
  elseif other.physicsShapeType == "Circle" then
    print("Other object is a Circle")
    local lastPoint = self.points[#self.points] or self.tailPos
    local incidentVector = self.headPos - lastPoint
    local normalVector = other.pos - self.pos

    print("incidentVector: "..tostring(incidentVector).." normalVector: "..tostring(normalVector))
    local incidentAngle = V(0,0):angleTo(incidentVector)
    local normalAngle = V(0,0):angleTo(normalVector)

    local angleDelta = normalAngle - incidentAngle
    -- adding pi is equivalent to rotating 180 degrees, which is neccessary for the rebound.
    local newAngle = incidentAngle + 2 * angleDelta + math.pi
    print(string.format("angleDelta = %f (radians). newAngle = %f", angleDelta, newAngle))

    local oldMagnitude = self.vel:len()
    self.vel = V(oldMagnitude * math.cos(newAngle), oldMagnitude * math.sin(newAngle))
    self:move(dt)
  end

  self:bounce()
end
