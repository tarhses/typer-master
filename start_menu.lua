local utf8 = require "utf8"
local Game = require "game"

local StartMenu = {}
StartMenu.__index = StartMenu

local NAME_MAX_LENGTH = 24
local FILL_CHAR = "_"

function StartMenu.new(font)
  local self = setmetatable({}, StartMenu)
  
  self.font = font
  self.name = {}
  self.name_length = 0
  
  for i = 1, NAME_MAX_LENGTH do
    table.insert(self.name, string.byte(FILL_CHAR))
  end
  
  return self
end

function StartMenu:enter(states)
  self.states = states
end

function StartMenu:draw()
  local x = 0
  local y = (love.graphics.getHeight() - self.font:getHeight() * 4) / 2
  local w = love.graphics.getWidth()
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(self.font)
  love.graphics.printf({
    {1, 1, 1, 0.7}, "Nom de l'équipe :\n\n",
    {1, 1, 1}, utf8.char(unpack(self.name))
  }, x, y, w, "center")
end

function StartMenu:key_pressed(key)
  if self.name_length > 0 then
    if key == "backspace" then
      self.name[self.name_length] = string.byte(FILL_CHAR)
      self.name_length = self.name_length - 1
    elseif key == "return" then
      self.states:set(Game.new(self.font))
    end
  end
end

function StartMenu:text_input(char)
  if self.name_length < NAME_MAX_LENGTH then
    self.name_length = self.name_length + 1
    self.name[self.name_length] = utf8.codepoint(char)
  end
end

return StartMenu
