GameObject = {}
GameObject.__index = GameObject

function GameObject.new(pos)
    local self = {}
    setmetatable(self, GameObject)

    self.pos = pos
    self.vel = V(0,0)
    self.physicsEnabled = false
    self.physicsShapeType = "Rectangle"
    self.width = 30
    self.height = 30
    self.tag = "Untagged"

    return self
end

function GameObject:setTag(tag)
    self.tag = tag
end

function GameObject:setPos(pos)
  self.pos = pos
  return self
end

function GameObject:setVel(vel)
  self.vel = vel
  return self
end

function GameObject:move(dt)
  self:setPos(self.pos + self.vel * dt)
  return self
end

function GameObject:collisionStart(other, dt, mtv_x, mtv_y)
end

function GameObject:collisionEnd(other, dt)
end
