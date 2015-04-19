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
  self.numBounces = 0 
  self.maxBounces = 10 -- it will die after this many bounces

  self.headPos = Utils.copy(initialPos)
  self.tailPos = Utils.copy(initialPos)

  -- self.pos is not used internally but is exposed externally so that a beam obeys the same interface
  -- as other game objects.
  self.pos = self.headPos

  self.color = {255, 255, 255}

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
  self.numBounces = self.numBounces + 1

  if self.numBounces == self.maxBounces then
      self:die()
  end
  table.insert(self.points, self.headPos)
  local newPos = Utils.copy(self.headPos)
  self.headPos = newPos
end

function Beam:die()
    print("Beam died.")
    self.dead = true
end

function Beam:collisionStart(other, dt, mtv_x, mtv_y)
  print(string.format("Beam:collisionStart called with mtv_x=%f, mtv_y = %f", mtv_x, mtv_y))
  if other.physicsShapeType == "Rectangle" then
    print("Other object is a Rectangle")

    local collisionPoint = self.pos
    local lastPoint = self.points[#self.points] or self.tailPos
    local velAngle = V(0,0):angleTo(self.vel)
    print(string.format("velAngle=%f", velAngle))

    local rectLeftX = other.pos.x - other.width/2
    local rectRightX = other.pos.x + other.width/2
    local rectTopY = other.pos.y - other.height/2
    local rectBottomY = other.pos.y + other.height/2

    local dx, dy
    dy = lastPoint.y - rectTopY
    dx = dy / math.tan( velAngle )
    local topCollisionX = lastPoint.x + dx

    dy = lastPoint.y - rectBottomY
    dx = dy / math.tan( velAngle )
    local bottomCollisionX = lastPoint.x + dx

    dx = lastPoint.x - rectLeftX
    dy = dx * math.tan( velAngle )
    local leftCollisionY = lastPoint.y + dy

    dx = lastPoint.x - rectRightX
    dy = dx * math.tan( velAngle )
    local rightCollisionY = lastPoint.y + dy

    local topCollision = rectLeftX < topCollisionX and topCollisionX < rectRightX
    local bottomCollision = rectLeftX < bottomCollisionX and bottomCollisionX < rectRightX 
    local leftCollision = rectTopY < leftCollisionY and leftCollisionY < rectBottomY 
    local rightCollision = rectTopY < rightCollisionY and rightCollisionY < rectBottomY

    local side = ""
    if topCollision and velAngle < 0 then
        side = "top"
    elseif bottomCollision and velAngle > 0 then
        side = "bottom"
    elseif leftCollision and (math.pi/2 > velAngle and velAngle > -math.pi/2) then
        side = "left"
    else
        side = "right"
    end

    print(string.format("rectTopY=%f, rectBottomY=%f, rectLeftX=%f, rectRightX=%f", rectTopY, rectBottomY, rectLeftX, rectRightX))
    print(string.format("topCollisionX=%f, bottomCollisionX=%f, leftCollisionY=%f, rightCollisionY=%f", topCollisionX, bottomCollisionX, leftCollisionY, rightCollisionY))

    print(string.format("Calculated nearest side to be %s", side))

    local newHeadPos
    if side == "top" then
      newHeadPos = V(topCollisionX, rectTopY)
      self.vel.y = self.vel.y * -1
    elseif side == "bottom" then
      newHeadPos = V(bottomCollisionX, rectBottomY)
      self.vel.y = self.vel.y * -1
    elseif side == "right" then
      newHeadPos = V(rectRightX, rightCollisionY)
      self.vel.x = self.vel.x * -1
    else -- side == "left"
      newHeadPos = V(rectLeftX, leftCollisionY)
      self.vel.x = self.vel.x * -1
    end

    -- Move the head to the intersection of the vector and the rectangle.
    print(string.format("newHeadPos=%s", tostring(newHeadPos)))
    self.headPos = newHeadPos

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
