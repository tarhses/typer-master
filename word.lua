local utf8 = require "utf8"
local Timer = require "hump.timer"

local Word = {}
Word.__index = Word

--- Create a new Word instance.
-- @param font the font used to display the word
-- @param text the rendered text
function Word.new(font, text)
  local self = setmetatable({}, Word)

  self.font = font
  self.chars = {utf8.codepoint(text, 1, #text)}
  self.cursor = 1
  self.x = 0
  self.y = 0
  self.a = 1
  
  return self
end

--- Get the next letter, pointed by the cursor.
-- @return the letter
function Word:get_letter()
  return utf8.char(self.chars[self.cursor])
end

--- Set the next letter as consumed.
-- @return whether the word is finished or not
function Word:consume_letter()
  self.cursor = self.cursor + 1
  return self.cursor > #self.chars
end

--- Display the word on screen.
function Word:draw()
  local y = self.y + (love.graphics.getHeight() - self.font:getHeight()) / 2
  local w = love.graphics.getWidth()
  
  love.graphics.setColor(1, 1, 1, self.a)
  love.graphics.printf({
    {1, 1, 1}, utf8.char(unpack(self.chars, 1, self.cursor - 1)),
    {1, 1, 1, 0.5}, utf8.char(unpack(self.chars, self.cursor))
  }, self.x, y, w, "center")
end

--- Tween the word attributes.
-- @see hump.timer
function Word:tween(duration, ...)
  Timer.tween(duration, self, ...)
end

return Word
