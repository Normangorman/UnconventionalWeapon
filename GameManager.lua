GameManager = {}
GameManager.__index = GameManager

function GameManager.new()
    local self = {}
    setmetatable(self, GameManager)

    love.physics.setMeter(64) -- 64px is one meter
    -- args are xgravity, ygravity, can bodies sleep?
    self.physicsWorld = love.physics.newWorld(0, 9.81*64, true)
    self.physicsWorld:setCallbacks(
        function(...) self:beginContact(...) end,
        function(...) self:endContact(...) end,
        function(...) self:preSolve(...) end,
        function(...) self:postSolve(...) end
    )

    self.entities = {}

    return self 
end

function GameManager:update(dt)
    for i, e in ipairs(self.entities) do
        e:update(dt)
        if e.dead then
            table.remove(self.entities, i) 
        end
    end

    self.physicsWorld:update(dt)
end

function GameManager:draw()
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
