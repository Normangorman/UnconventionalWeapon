Vector2 = {}
Vector2.__index = Position

function Vector2.new(x, y)
    local self = {}
    setmetatable(self, Vector2)

    self.x = x or 0
    self.y = y or 0

    return self
end

function Vector2.add(a, b)
    return Vector2.new(a.x + b.x, a.y + b.y)
end

function Vector2:magnitude()
    return math.sqrt( math.pow(math.abs(self.x), 2) + math.pow(math.abs(self.y), 2) )
end

function Vector2:angleTo(other) -- in radians
    local deltaY = other.y - self.y
    local deltaX = other.x - self.x
    return math.atan2(deltaY, deltaX)
end

function Vector2:xy()
  return self.x, self.y
end

function Vector2.assert(v)
  assertint(v.x, v.y)
end

Vector2.__add = Vector2.add

