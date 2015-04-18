Vector2 = {}
Vector2.__index = Position
Vector2.__add = Vector2.add

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
