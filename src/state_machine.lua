local class = require "class"

local StateMachine = class()

--- Create a new StateMachine instance.
-- @param state the initial state
-- @param ... parameters sent to the state
function StateMachine:initialize(state, ...)
  self.state = state
  self:call("enter", self, ...)
end

--- Change the current state.
-- @param state the new state
-- @param ... parameters sent to the entered state
function StateMachine:set(state, ...)
  self:call("leave", self)
  self.state = state
  self:call("enter", self, ...)
end

--- Call a callback of the current state.
-- @param name name of the callback
-- @param ... parameters sent to the callback
function StateMachine:call(name, ...)
  local callback = self.state[name]
  if callback then
    callback(self.state, ...)
  end
end

return StateMachine
