local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(initial_state, ...)
  local self = setmetatable({}, StateMachine)
  
  self.state = initial_state
  self.states = {initial_state}
  self:call("enter", self, ...)
  
  return self
end

function StateMachine:push(state, ...)
  self.state = state
  table.insert(self.states, state)
  self:call("enter", self, ...)
end

function StateMachine:pop(...)
  self:call("leave", self)
  table.remove(self.states)
  self.state = self.states[#self.states]
  self:call("enter", self, ...)
end

function StateMachine:set(state, ...)
  self:call("leave", self)
  self.state = state
  self.states[#self.states] = self.state
  self:call("enter", self, ...)
end

function StateMachine:call(name, ...)
  local callback = self.state[name]
  if callback then
    callback(self.state, ...)
  end
end

return StateMachine
