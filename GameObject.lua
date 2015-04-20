GameObject = {}
GameObject.__index = GameObject

function GameObject.new(game)
    local self = {}
    setmetatable(self, GameObject)

    self.game = game

    -- All objects must have a relevant tag.
    self.tag = "Untagged"

    -- Objects should set this to be true if they use the physics system.
    self.hasPhysics = false

    -- If self.dead == true then the object will be deleted by the game manager.
    self.dead = false

    return self
end

function GameObject:update(dt) end
function GameObject:draw() end
