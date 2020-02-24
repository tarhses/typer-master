local StateMachine = {}
StateMachine.__index = StateMachine

--- Create a new StateMachine instance.
-- @param intial_state the initial state of the state machine
-- @param ... parameters sent to the state
function StateMachine.new(initial_state, ...)
  local self = setmetatable({}, StateMachine)
  
  self.state = initial_state
  self.states = {initial_state}
  self:call("enter", self, ...)
  
  return self
end

--- Push a new state on the stack, and enter it.
-- @param state the new state
-- @param ... parameters sent to the entered state
function StateMachine:push(state, ...)
  self.state = state
  table.insert(self.states, state)
  self:call("enter", self, ...)
end

--- Pop the current state on the stack, and enter the one below it.
-- @param ... parameters sent to the entered state
function StateMachine:pop(...)
  self:call("leave", self)
  table.remove(self.states)
  self.state = self.states[#self.states]
  self:call("enter", self, ...)
end

--- Change the current state.
-- @param state the new state
-- @param ... parameters sent to the entered state
function StateMachine:set(state, ...)
  self:call("leave", self)
  self.state = state
  self.states[#self.states] = self.state
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
