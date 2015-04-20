EnemyTypes = {}

EnemyTypes.purplegloop = function(...)
    local self = Enemy.new(...)
    self.animation = Animation.newFromFile("Animations/purplegloop.lua")

    return self
end

EnemyTypes.pinkwhirl = function(...)
    local self = Enemy.new(...)
    self.animation = Animation.newFromFile("Animations/pinkwhirl.lua")

    return self
end
