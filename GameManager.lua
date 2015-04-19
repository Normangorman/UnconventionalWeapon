GameManager = {}
GameManager.__index = GameManager

function GameManager.new()
  local self = {}
  setmetatable(self, GameManager)

  self.physics = HC(
    1,
    function(...)
        self:onCollisionStart(...)
    end,
    function(...)
        self:onCollisionStop(...)
    end
  )

  self.entities = {}
  -- A mapping between entities and their physics objects.
  self.entityPhysicsObjectMap = {}

  return self 
end

function GameManager:update(dt)
  for _, e in ipairs(self.entities) do
    e:update(dt)
    self.entityPhysicsObjectMap[e]:moveTo(e.pos.x, e.pos.y)
  end

  self.physics:update(dt)
end

function GameManager:draw()
  for _, e in ipairs(self.entities) do
    e:draw()
  end
end

function GameManager:addEntity(e)
  assert(e.physicsShapeType ~= nil)

  table.insert(self.entities, e)

  local physicsObject
  local shape = e.physicsShapeType

  if shape == "Rectangle" then
      assert(e.width ~= nil, e.height ~= nil)
      physicsObject = self.physics:addRectangle(e.pos.x, e.pos.y, e.width, e.height)
  elseif shape == "Circle" then
      assert(e.radius ~= nil)
      physicsObject = self.physics:addCircle(e.pos.x, e.pos.y, e.radius)
  elseif shape == "Point" then
      physicsObject = self.physics:addPoint(e.pos.x, e.pos.y)
  end

  physicsObject._owner = e
  self.entityPhysicsObjectMap[e] = physicsObject
end

function GameManager:removeEntity(e)
    for i, entity in ipairs(self.entities) do
        if e == entity then
            table.remove(self.entities, i)
            break
        end
    end

    self.entityPhysicsObjectMap[e] = nil
end

function GameManager:onCollisionStart(dt, shape_a, shape_b, mtv_x, mtv_y)
    print(string.format("Collision started! shape_a._owner.tag = %s, shape_b._owner.tag = %s", shape_a._owner.tag, shape_b._owner.tag))

    shape_a._owner:collisionStart(shape_b._owner, dt, mtv_x, mtv_y)
    shape_b._owner:collisionStart(shape_a._owner, dt, mtv_x, mtv_y)
end

function GameManager:onCollisionStop(dt, shape_a, shape_b)
    print(string.format("Collision stopped! shape_a._owner.tag = %s, shape_b._owner.tag = %s", shape_a._owner.tag, shape_b._owner.tag))

    shape_a._owner:collisionStop(shape_b._owner, dt)
end
