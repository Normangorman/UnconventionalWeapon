require "Vector2"
Object = {}
function Object:setPos(pos)
  assert(pos)
  Vector2.assert(pos)
  self.pos = pos
  return self
end

function Object:setVel(vel)
  assert(vel)
  Vector2.assert(vel)
  self.vel = vel
  return self
end

function Object:move(dt)
  Object:setPos(self.pos * self.vel * dt)
end
