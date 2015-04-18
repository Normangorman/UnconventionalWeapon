require "Vector2"

Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
    local self = {}
    setmetatable(self, Enemy)

    self.position = Vector2.new(0, 0)
    self.velocity = Vector2.new(0, 0)
    self.width = 25
    self.height = 25
    self.color = {255,255,0}

    return self
end

function Enemy:draw()
    love.graphics.setColor( unpack(self.color) )
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
    love.graphics.setColor(255,255,255)
end

function Enemy:update(dt)
    self.position = self.position + self.velocity
end
