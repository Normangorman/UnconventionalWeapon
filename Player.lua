require "Vector2"
require "Beam"

Player = {}
Player.__index = Player

function Player.new()
  local self = {}
  setmetatable(self, Player)

  self.position = Vector2.new(0,0)
  self.velocity = Vector2.new(0,0)
  self.color = {255,255,255}
  self.width = 30
  self.height = 30

  return self
end

function Player:setPos(v)
  self.position = v
end

function Player:setVel(v)
  self.velocity = v
end

function Player:draw()
  love.graphics.setColor( unpack(self.color) )
  love.graphics.rectangle("fill", self.position.x, self.position.y, self.width, self.height)
  love.graphics.setColor(255,255,255)
end

function Player:update(dt)
  self.position = self.position + self.velocity
end

function Player:mousepressed(mx, my, button)
  local mouseVector = Vector2.new(mx, my)
  local angle = self.position:angleTo(mouseVector) 
  local beam = Beam.new(self.position, angle)

  GAME_MANAGER:addEntity(beam)
end
