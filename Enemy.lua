Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
    local self = {}
    setmetatable(self, Enemy)

    Enemy.position = Vector2.new(0, 0)
    Enemy.velocity = Vector2.new(0, 0)
end
