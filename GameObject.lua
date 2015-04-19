GameObject = {}
GameObject.__index = GameObject

function GameObject.new(pos)
    local self = {}
    setmetatable(self, GameObject)

    self.pos = pos
    self.vel = V(0,0)

    -- Physics shape type is used by GameManager when adding objects to the physics engine.
    -- Objects are responsible for setting their own shape type and dimensions, and resolving their own collisions.
    self.physicsShapeType = "Rectangle" -- other options are "Circle" or "Point" or "Polygon"
    -- if "Rectangle" then width and height should be defined
    self.width = 30
    self.height = 30
    -- if "Circle" then radius should be defined
    self.radius = nil
    -- if "Polygon" then polygonPoints should be defined
    self.polygonPoints = nil

    -- A tag is no more than a name for an object's class.
    -- It is not used in the physics engine code.
    -- Its main use is in collision resolution functions. E.g. a beam can check whether it hits a player,
    -- in which case it damages the player - or a block in which case it rebounds.
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

function GameObject:collisionStop(other, dt)
end
