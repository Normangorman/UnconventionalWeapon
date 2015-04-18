Object = {}
function Object:setPos(pos)
  self.pos = pos
  return self
end

function Object:setVel(vel)
  self.vel = vel
  return self
end

function Object:move(dt)
  self:setPos(self.pos + self.vel * dt)
  return self
end

function Object.copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[Object.copy(k, s)] = Object.copy(v, s) end
  return res
end

