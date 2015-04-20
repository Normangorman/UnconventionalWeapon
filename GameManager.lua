GameManager = {}
GameManager.__index = GameManager

function GameManager.new()
    local self = {}
    setmetatable(self, GameManager)

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

    local enemy1 = EnemyTypes.purplegloop(self, V(100,100))
    enemy1.animation:play()

    self:addEntity(player)
    self:addEntity(enemy1)

    self.backgroundImage = love.graphics.newImage("Assets/background_960x800.png")

    return self 
end

function GameManager:update(dt)
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
            table.remove(self.entities, i) 
        end
    end
end

function GameManager:draw()
    love.graphics.draw(self.backgroundImage, 0, 0)
    self.map:draw()

    for _, e in ipairs(self.entities) do
        e:draw()
    end
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
