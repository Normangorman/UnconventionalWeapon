require "Object"
Beam = {}
Beam.__index = Beam

Beam.setPos = Object.setPos
Beam.setVel = Object.setVel



function Beam:update(dt)
  self:move(dt)

  local points = Object.copy(self.points)
  table.insert(points, self.pos)
  local index = #points
  local distance = self.length
  while true do
    distance = distance - math.abs(points[index]:dist(points[index - 1]))
    index = index - 1
    if distance < 0 then
      break
    elseif index == 1 then
      index = 0 -- don't do the next for loop
      break
    end
  end
  
  --        B********C    Since A is out of range, 
  --       *              we want to calculate a to replace it
  --      *
  --     *
  --   [a]
  --   -
  --  A
  --
  -- Reminder: B -> A is calculated by (A - B)
  
  for i = 1, index do
    local A = table.remove(self.points, 1)
    if i == 1 then
      local B = self.points[1]
      olddistance = A:dist(B)
      newdistance = math.abs(A:dist(B)) + distance -- add the negative distance
      -- to get a shorter distance. We're going to work out the end point on that shorter distance
      a = (A - B) * (newdistance / olddistance) + B
      table.insert(self.points, 1, a)
    end
  end
end

Beam.setPos = Object.setPos
Beam.setVel = Object.setVel
Beam.move = Object.move

function Beam:setLength(length)
  self.length = length
end

function Beam:draw()
  love.graphics.setColor(100, 150, 100)
  local points = Object.copy(self.points)
  table.insert(points, self.pos)
  for i = 1, (#points - 1) do
    print(#points .. " " .. type(points[i + 1]))
    love.graphics.line(points[i].x, points[i].y, points[i+1].x, points[i+1].y)
  end
  love.graphics.setColor(255,255,255)
end

function Beam.new()
  self = {}
  setmetatable(self, Beam)
  self.points = {}
  self:setPos(V(50, 50))
  self:setVel(V(0, 0))
  self:bounce(V(0, 0))
  self:setLength(100)
  return self
end

function Beam:bounce(pos)
  table.insert(self.points, pos)
end
