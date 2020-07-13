local Object = {}

function Object.initialize()
  -- Do nothing by default
end

local function new_object(class, ...)
  local self = setmetatable({}, class)
  self:initialize(...)
  return self
end

local function new_class(parent)
  local class = setmetatable({}, { __index = parent or Object, __call = new_object })
  class.__index = class
  return class
end

return new_class
