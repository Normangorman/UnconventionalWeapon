Utils = {}

function Utils.copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[Utils.copy(k, s)] = Utils.copy(v, s) end
  return res
end

function Utils.stack()
    local stack = {}

    function stack:push(x) table.insert(self, x) end
    function stack:pop() return table.remove(self) end

    function stack:pushBase(x) table.insert(self, 1, x) end
    function stack:popBase() return table.remove(self, 1) end

    return stack
end
