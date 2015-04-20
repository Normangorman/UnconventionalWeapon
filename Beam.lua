Beam = {}
Beam.__index = Beam

function Beam.new(game, pos, angle, vel_mag)
    local self = GameObject.new(game)
    setmetatable(self, Beam)

    self.tag = "Beam"
    self.hasPhysics = false -- it's querying the physics world, but it's not actually in the physics world.

    self.physicsWorld = game:getPhysicsWorld()

    self.points = Utils.stack()
    self.numBounces = 0
    self.maxBounces = 7 -- it will die after this many bounces
    self.maxLength = 200

    self.tailPos = pos:clone()
    self.headPos = pos:clone()

    self.vel = V(vel_mag*math.cos(angle), vel_mag*math.sin(angle))

    return self
end

function Beam:handleRayCastCollision(fixture, x, y, xn, yn, fraction)
    -- x and y are the co-ordinates of the intersection point 
    -- xn and yn are the components of the normal vector to the edge of the shape
    -- fraction is the proportion of the casted ray at which the intersection point lies
    
    -- print "Beam:handleRayCastCollision was called."
    -- print(string.format("x=%f, y=%f, xn=%f, yn=%f, fraction=%f", x,y,xn,yn,fraction))

    local fixtureOwner = fixture:getUserData()
    if fixtureOwner.tag == "Player" then
        local player = fixtureOwner

        if fixture == player.outerFixture then
            local isBounced = player:tryBounceBeam(x,y,xn,yn)

            if not isBounced then
                return 0    
            end
        else -- fixture == player.innerFixture
            player:hurt(1)
            self:die()
        end
    end

    -- Change the position of the bullet to be the position of the collision
    self.headPos.x = x
    self.headPos.y = y
    self:bounce()

    -- Reflect the velocity of the bullet in the normal vector to the shape
    -- The formula for this is r = d - 2 * (d . n) * n
    -- where r is the reflection vector, d is the incident vector, n is the normal vector and . is the dot product
    local d = self.vel
    local n = V(xn, yn)
    
    local r = d - 2*(d*n)*n

    -- print(string.format("d=%s, n=%s, r=%s", tostring(d), tostring(n), tostring(r)))

    self.vel = r

    -- The return value here indicates what the new length of the ray should be.
    -- This is only needed when you expect the ray to hit multiple points.
    -- Since we only want it to hit one point, by setting the value to 0 the ray is terminated.
    return 0
end

function Beam:update(dt)
    -- Move the head:
    local current_pos = self.headPos
    local next_pos = self.headPos + self.vel * dt

    -- Assumes that only one point is hit
    self.physicsWorld:rayCast(current_pos.x, current_pos.y, next_pos.x, next_pos.y, function(...)
        return self:handleRayCastCollision(...)
    end)

    self.headPos = self.headPos + self.vel * dt

    -- Move the tail:
    if self:getLength() > self.maxLength then
        local vel_mag = self.vel:len() * dt

        -- Calculate the velocity that the tail needs to travel at.
        local tailDestination = self.points[1] or self.headPos

        local destinationDelta = tailDestination - self.tailPos
        local destinationAngle = destinationDelta:angleTo()

        local tailVel = V(vel_mag * math.cos(destinationAngle), vel_mag * math.sin(destinationAngle))

        if tailVel:len() > destinationDelta:len() then
            self.tailPos = tailDestination
            self.points:popBase()
        else
            self.tailPos = self.tailPos + tailVel
        end
    end
end

function Beam:getActivePoints()
    local points = Utils.copy(self.points)

    points:pushBase(self.tailPos)
    points:push(self.headPos)

    return points
end

function Beam:getLength()
    local points = self:getActivePoints()
    local length = 0
    for i=1, #points-1 do
        length = length + (points[i+1] - points[i]):len()
    end

    return length
end


function Beam:bounce()
    self.numBounces = self.numBounces + 1

    if self.numBounces == self.maxBounces then
        self:die()
    end

    self.points:push(self.headPos)
end

function Beam:die()
    print("Beam:die called")
    self.dead = true
end

function Beam:draw()
    love.graphics.setColor(193,17,14)

    -- Connect all the points in the stack
    local points = self:getActivePoints()
    
    for i=1, #points-1 do
        love.graphics.line(points[i].x, points[i].y, points[i+1].x, points[i+1].y)
    end

    love.graphics.setColor(255,255,255)
end

function Beam:getDebugText()
    return string.format( [[
        bullet.headPos.x = %f,
        bullet.headPos.y = %f,
        bullet.vel.x = %f,
        bullet.vel.y = %f,
        #bullet.points = %d
        ]],
        self.headPos.x,
        self.headPos.y,
        self.vel.x,
        self.vel.y,
        #self.points
    )
end
