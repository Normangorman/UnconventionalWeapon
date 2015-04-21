GameManager = {}
GameManager.__index = GameManager

function GameManager.new()
    local self = {}
    setmetatable(self, GameManager)

    -- UI
    self.UI = UIManager.new()
    local font = love.graphics.newFont("Assets/ASMAN.TTF", 40)
    self.healthText = Text.new("Health: 10", 38, 38, 500, "left", nil, font)
    self.scoreText = Text.new("Score: 0", 238, 38, 500, "left", nil, font)
    self.waveText = Text.new("Wave: 1", 438, 38, 500, "left", nil, font)

    self.UI:addWidget(self.healthText)
    self.UI:addWidget(self.scoreText)
    self.UI:addWidget(self.waveText)

    -- Physics
    love.physics.setMeter(64) -- 64px is one meter
    -- args are xgravity, ygravity, can bodies sleep?
    self.physicsWorld = love.physics.newWorld(0, 9.81*64, true)
    self.physicsWorld:setCallbacks(
        function(...) self:beginContact(...) end,
        function(...) self:endContact(...) end,
        function(...) self:preSolve(...) end,
        function(...) self:postSolve(...) end
    )

    -- Tilemap
    local map = STI.new("Maps/map1")
    map:initWorldCollision(self.physicsWorld)
    self.map = map

    -- Pathfinding
    self.rawMapData = {
        {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 2},
        {2, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 2},
        {2, 0, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2},
        {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2}
      }

    local grid = Jumper_Grid(self.rawMapData)
    local walkable = 0
    self.pathfinder = Jumper_Pathfinder(grid, 'JPS', walkable)

    -- Entities
    self.entities = {}
    local player = Player.new(self, V(500,300))
    self.player = player
    self.playerScore = 0

    self.enemyCount = 0
    self.nextWaveNumber = 1
    self.waveStarting = false
    self.waveStartTimer = 0

    self:addEntity(player)

    self.backgroundImage = love.graphics.newImage("Assets/background_960x800.png")

    return self 
end

function GameManager:update(dt)
    -- Handle waves:
    if self.enemyCount == 0 and not self.waveStarting then 
        self.waveStarting = true
        self.waveStartTimer = 2.0
    end

    if self.waveStarting then
        if self.waveStartTimer <= 0 then -- spawn the enemies
            print(string.format("WAVE %d STARTING", self.nextWaveNumber))
            local spawnPoints = {
                V(48,48), V(896,48),
                V(48,736), V(896,736)
            }
            local numEnemies = self.nextWaveNumber

            for i=1,numEnemies do
                -- Choose a random spawn point from the list
                local spawnPointIndex = math.floor(love.math.random(1.0, 4.99))
                local spawnPoint = spawnPoints[spawnPointIndex]

                local enemy
                if math.random() > 0.5 then
                    enemy = EnemyTypes.purplegloop(self, spawnPoint)
                else
                    enemy = EnemyTypes.pinkwhirl(self, spawnPoint)
                end
                enemy.animation:play()
                self:addEntity(enemy)
            end

            self.enemyCount = numEnemies
            self.nextWaveNumber = self.nextWaveNumber + 1
            self.waveStarting = false
        else -- reduce the timer
            self.waveStartTimer = self.waveStartTimer - dt
        end
    end

    local vx, vy = self.player.body:getLinearVelocity()

    local speed = 300
    if love.keyboard.isDown('left') then
        vx = vx - speed
    elseif love.keyboard.isDown('right') then
        vx = vx + speed
    end

    if love.keyboard.isDown('up') then
        vy = vy - speed
    elseif love.keyboard.isDown('down') then
        vy = vy + speed
    end

    self.player.body:setLinearVelocity(vx, vy)

    self.physicsWorld:update(dt)

    for i, e in ipairs(self.entities) do
        e:update(dt)
        if e.dead then
            print("GameManager removed dead entity.")
            table.remove(self.entities, i) 
        end
    end

    -- Update UI
    self.healthText:setText("Health: "..tostring(self.player.health))
    self.scoreText:setText("Score: "..tostring(self.playerScore))
    self.waveText:setText("Wave: "..tostring(self.nextWaveNumber - 1))
    self.UI:update(dt)
end

function GameManager:draw()
    love.graphics.draw(self.backgroundImage, 0, 0)
    self.map:draw()

    for _, e in ipairs(self.entities) do
        e:draw()
    end

    self.UI:draw()
end

function GameManager:getPhysicsWorld()
    return self.physicsWorld
end

-- COLLISION RESPONSE:
-- a and b are fixtures, coll is the collision point.
function GameManager:beginContact(a,b,coll)
end

function GameManager:endContact(a,b,coll)
    local a_user = a:getUserData()
    local b_user = b:getUserData()

    print("endContact called")
    print(string.format("a_user.tag=%s, b_user.tag=%s", a_user.tag, b_user.tag))
end

-- preSolve and postSolve can be called multiple times in between beginContact and endContact
function GameManager:preSolve(a,b,coll)
end

function GameManager:postSolve(a,b,coll, normalImpulse1, tangentImpulse1, normalImpulse2, tangentImpulse2)
end

function GameManager:addEntity(e)
    table.insert(self.entities, e)
end

function GameManager:removeEntity(e)
    for i, entity in ipairs(self.entities) do
        if e == entity then
            table.remove(self.entities, i)
            break
        end
    end
end

function GameManager:keypressed(key, isRep)
end

function GameManager:mousepressed(mx, my, button)
end
