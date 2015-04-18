Player = {}
Player.__index = Player

function Player.new()
    local self = {}
    setmetatable(self, Player)

    self.x = 0
    self.vx = 0
    self.y = 0
    self.vy = 0
    self.width = 30
    self.height = 30

    return self
end

function Player:draw()
    love.graphics.setColor(125,125,125)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(255,255,255)
end

function Player:update(dt)
    self.x = self.x + self.vx
    self.y = self.y + self.vy
end
