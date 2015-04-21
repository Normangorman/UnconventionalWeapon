Player = {}
setmetatable(Player, GameObject)
Player.__index = Player

function Player.new(game, pos)
    local self = GameObject.new(game)
    setmetatable(self, Player)

    -- General settings
    self.tag = "Player" self.hasPhysics = true 
    self.mirrorRotation = math.pi / 2 -- directly above the player
    self.mirrorAngleSize = math.pi / 2 

    self.innerRadius = 30
    self.outerRadius = 65

    self.color = {255,255,255}
    self.health = 10


    -- Physics settings
    self.body = love.physics.newBody(game:getPhysicsWorld(), pos.x, pos.y, "kinematic")

    self.innerShape = love.physics.newCircleShape(self.innerRadius)
    self.innerFixture = love.physics.newFixture(self.body, self.innerShape)
    self.innerFixture:setUserData(self)

    self.outerShape = love.physics.newCircleShape(self.outerRadius)
    self.outerFixture = love.physics.newFixture(self.body, self.outerShape)
    self.outerFixture:setUserData(self)

    return self
end

function Player:update(dt)
    local mousePos = V(love.mouse.getPosition())
    local delta = mousePos - self:getPos()

    local newMirrorRotation = delta:angleTo() - self.mirrorAngleSize / 2

    self.mirrorRotation = newMirrorRotation

    self.body:setLinearVelocity(0,0)
end

function Player:draw()
    local x,y = self.body:getX(), self.body:getY()
    love.graphics.setColor( unpack(self.color) )
    love.graphics.circle("fill", x, y, self.innerRadius)
    love.graphics.setColor(255,255,255)

    -- Draw the mirror
    local mirrorStartAngle = self.mirrorRotation 
    local mirrorEndAngle = mirrorStartAngle + self.mirrorAngleSize

    local stencilFunction = function()
        love.graphics.circle("line", x, y, self.outerRadius)
    end

    love.graphics.setStencil(stencilFunction)
    love.graphics.arc("line", x, y, self.outerRadius, mirrorStartAngle, mirrorEndAngle) 
    love.graphics.setStencil()
end

function Player:getPos()
    return V(self.body:getX(), self.body:getY())
end

function Player:mousepressed(mx, my, button)
end

function Player:hurt(amount)
    print(string.format("Player was hurt by %d. Current health = %d", amount, self.health))
    self.health = self.health - amount

    if self.health == 0 then
        HIGH_SCORE = self.game.playerScore
        LEVEL_MANAGER:changeLevel("menu")
    end
end

function Player:tryBounceBeam(x,y,nx,ny)
    print("Player:tryBounceBeam called")
    local collDir = V(x,y) - self:getPos()
    local startDir = V(math.cos(self.mirrorRotation), math.sin(self.mirrorRotation))
    local endDir = V(math.cos(self.mirrorRotation + self.mirrorAngleSize), math.sin(self.mirrorRotation + self.mirrorAngleSize))

    
    local collToStart = math.acos( (collDir * startDir) / (collDir:len() * startDir:len()) )
    local collToEnd = math.acos( (collDir * endDir) / (collDir:len() * endDir:len()) )

    print(string.format("collToStart=%f, collToEnd=%f", collToStart, collToEnd))

    if collToStart < self.mirrorAngleSize and collToEnd < self.mirrorAngleSize then
        return true
    else
        return false
    end
end

function Player:debugBeam(mx, my)
    print(string.format("debugBeam called with mx=%f, my=%f", mx, my))
    local delta = V(mx, my) - self:getPos()
    local angle = delta:angleTo()
    local beamPos = V(mx, my)

    print(string.format("delta=%s, angle=%f, beamPos=%s", tostring(delta), angle, tostring(beamPos)))
    local beam = Beam.new(self.game, beamPos, angle + math.pi, 500)
    self.game:addEntity(beam)
end
