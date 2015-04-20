Enemy = {}
setmetatable(Enemy, GameObject)
Enemy.__index = Enemy

-- Don't create an enemy type directly - use something from EnemyTypes instead.
function Enemy.new(game, pos)
    local self = GameObject.new(game)
    setmetatable(self, Enemy)

    -- General settings
    self.tag = "Enemy"
    self.hasPhysics = true

    self.radius = 32
    self.color = {255,255,0}
    self.animation = nil
    
    -- Physics settings
    self.body = love.physics.newBody(game:getPhysicsWorld(), pos.x, pos.y, "static")
    self.shape = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)

    return self
end

function Enemy:update(dt)
    if self.animation then
        self.animation:update(dt)
    end

    if math.random() < 0.01 then
        self:attack()
    end
end

function Enemy:getPos()
    return V(self.body:getX(), self.body:getY())
end

function Enemy:draw()
    love.graphics.setColor( unpack(self.color) )
    local pos = self:getPos()
    if self.animation then
        -- animation:draw assumes the position given is the top-left corner
        self.animation:draw(pos.x - self.radius, pos.y - self.radius)
    else
        love.graphics.circle("fill", pos.x, pos.y, self.radius)
    end
    love.graphics.setColor(255,255,255)
end

function Enemy:attack()
    local theta = 0 -- math.random() * math.pi * 2
    local selfPos = self:getPos()
    local beamOffset = self.radius + 1
    local beamPos = selfPos + V(beamOffset * math.cos(theta), beamOffset * math.sin(theta))

    local beamVel = 1000 - 500 * math.random()

    local beam = Beam.new(self.game, beamPos, theta, beamVel)
    self.game:addEntity(beam)
end
