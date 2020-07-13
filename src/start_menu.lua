local utf8 = require "utf8"
local class = require "class"
local Game = require "game"

local StartMenu = class()

local NAME_MAX_LENGTH = 24
local FILL_CHAR = "_"

--- Create a new StartMenu instance.
-- @param font the font used to display the text on screen
function StartMenu:initialize(font)
  self.font = font
  self.name = {}
  self.name_length = 0
  
  for i = 1, NAME_MAX_LENGTH do
    table.insert(self.name, string.byte(FILL_CHAR))
  end
end

--- Callback when entering the state.
-- @param states state machine containing the state
function StartMenu:enter(states)
  self.states = states
end

--- Display the state on screen.
function StartMenu:draw()
  local x = 0
  local y = (love.graphics.getHeight() - self.font:getHeight() * 3) / 2
  local w = love.graphics.getWidth()
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(self.font)
  love.graphics.printf({
    {1, 1, 1, 0.7}, "Player Name :\n\n",
    {1, 1, 1}, utf8.char(unpack(self.name))
  }, x, y, w, "center")
end

--- Handle key pressed.
-- @param key the key pressed
function StartMenu:key_pressed(key)
  if self.name_length > 0 then
    if key == "backspace" then
      self.name[self.name_length] = string.byte(FILL_CHAR)
      self.name_length = self.name_length - 1
    elseif key == "return" then
      self.states:set(Game(self.font, utf8.char(unpack(self.name, 1, self.name_length))))
    end
  end
end

--- Handle text input.
-- @param char entered character
function StartMenu:text_input(char)
  if self.name_length < NAME_MAX_LENGTH then
    self.name_length = self.name_length + 1
    self.name[self.name_length] = utf8.codepoint(char)
  end
end

return StartMenu
