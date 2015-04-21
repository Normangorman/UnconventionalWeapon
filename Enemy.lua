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

    self.hasDestination = false
    self.pathPoints = Utils.stack()
    self.velMagnitude = 100
    
    -- Physics settings
    self.body = love.physics.newBody(game:getPhysicsWorld(), pos.x, pos.y, "kinematic")
    self.shape = love.physics.newCircleShape(self.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)

    return self
end

function Enemy:update(dt)
    if self.animation then
        self.animation:update(dt)
    end

    if math.random() < 0.0085 then
        self:attack()
    end

    if not self.hasDestination then
        -- Assumes the width of the map in tiles is 32 and the height is 25
        local pos = self:getPos()

        local currentTileX = math.floor(pos.x / 32) + 1
        local currentTileY = math.floor(pos.y / 32) + 1

        --print(string.format("currentTileX=%d, currentTileY=%d", currentTileX, currentTileY))

        -- Pick a random destination tile that isn't solid.
        local destinationTileX, destinationTileY
        local destinationFound = false
        while destinationFound == false do
            destinationTileX = math.floor( love.math.random(2.0, 29.99) )
            destinationTileY = math.floor( love.math.random(2.0, 24.99) )

            if self.game.rawMapData[destinationTileY][destinationTileX] == 0 then
                destinationFound = true
            end
        end
        --print("Destination found:")
        --print(string.format("destinationTileX=%d, destinationTileY=%d", destinationTileX, destinationTileY))

        local path, length = self.game.pathfinder:getPath(currentTileX, currentTileY, destinationTileX, destinationTileY)

        if path then
            for node, count in path:iter() do
                local point = V(node:getX()*32 + 16, node:getY()*32 + 16)
                self.pathPoints:push(point)
            end
        end
        self.hasDestination = true
    else
        if #self.pathPoints == 0 then
            self.hasDestination = false
            --print("Destination reached")
        else
            local nextPoint = self.pathPoints[1]
            if self:getPos():dist(nextPoint) < 8 then
                self.pathPoints:popBase()
            else
                dirVector = (nextPoint - self:getPos()):normalized()
                local velVector = self.velMagnitude * dirVector

                self.body:setLinearVelocity(velVector.x, velVector.y)
            end
        end
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
    local player = self.game.player
    local theta = (player:getPos() - self:getPos()):angleTo()

    local beamOffset = self.radius + 1
    local beamPos = self:getPos() + V(beamOffset * math.cos(theta), beamOffset * math.sin(theta))
    local beamVel = 800 - 300 * math.random()

    local beam = Beam.new(self.game, beamPos, theta, beamVel)
    self.game:addEntity(beam)
end

function Enemy:die()
    print("Enemy was killed!")
    if self.dead then return end -- fixes bug where multiple lasers hit an enemy during the same frame
    self.game.playerScore = self.game.playerScore + 1
    self.game.enemyCount = self.game.enemyCount - 1
    self.dead = true
end
