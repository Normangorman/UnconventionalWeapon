require "Vector2"
Object = {}
function Object:setPos(pos)
  Vector2.assert(pos)
  assert(self.pos, "Game object has no position")
  self.pos = pos
end

function Object:setPos(vel)
  Vector2.assert(vel)
  assert(self.vel, "Game object has no velocity")
  self.vel = vel
end

