Player = {}
Player.__index = Player

function Player.new()
    local self = {}
    setmetatable(self, Player)

    self.position = Vector2.new(0,0)
    self.velocity = Vector2.new(0,0)

    self.width = 30
    self.height = 30

    return self
end

function Player:draw()
    love.graphics.setColor(125,125,125)
    love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
    love.graphics.setColor(255,255,255)
end

function Player:update(dt)
    self.position = self.position + self.velocity
end
