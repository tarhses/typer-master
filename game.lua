local Leaderboard = require "leaderboard"
local Word = require "word"
local WORDS = require "words"

local Game = {}
Game.__index = Game

local RIGHT_BONUS = 5
local WRONG_MALUS = 3
local DURATION = 2 * 60 + 1

--- Return a given time as a readable format (mm:ss).
-- @param timer given time (in seconds)
-- @return a string containing the formatted timer
local function format_timer(timer)
  local minutes = math.floor(timer / 60)
  local seconds = math.floor(timer % 60)
  if seconds >= 10 then
    return minutes .. ":" .. seconds
  else
    return minutes .. ":0" .. seconds
  end
end

--- Create a new Game instance.
-- @param font font used to display text
function Game.new(font)
  local self = setmetatable({}, Game)
  
  -- Game related
  self.font = font
  self.score = 0
  self.timer = DURATION
  
  -- Words
  self.words = {Word.new(self.font, self:pick_word())}
  self:new_word()
  
  -- Stats related
  self.n_words = 0
  self.n_letters = 0
  self.n_errors = 0

  return self
end

function Game:enter(states)
  self.states = states
end

--- Select a new (and different) random word.
-- @return the selected word
function Game:pick_word()
  local index
  if self.word_index == nil then
    index = love.math.random(#WORDS)
  else
    -- Avoid taking the same word twice in a row
    index = love.math.random(#WORDS - 1)
    if index == self.word_index then
      index = index + 1
    end
  end
  
  self.word_index = index
  return WORDS[index]
end

--- Add a new word on the screen.
function Game:new_word()
  -- Get rid of the current word
  if self.word then
    self.word:tween(0.6, {y = -love.graphics.getHeight(), a = 0}, "inCubic")
  end
  
  -- Move the new word up
  self.word = self.words[#self.words]
  self.word:tween(0.4, {y = 0, a = 1}, "outCubic")
  
  -- Add a new word below
  local word = Word.new(self.font, self:pick_word())
  word.y = 64
  word.a = 0
  word:tween(0.4, {a = 0.5})
  table.insert(self.words, word)
end

--- Handle game update.
-- @dt time elapsed since last frame (in seconds)
function Game:update(dt)
  -- Timer
  self.timer = self.timer - dt
  if self.timer <= 0 then
    self.timer = 0
    self.states:set(Leaderboard.new(self.font, self.score, self.n_words, self.n_letters, self.n_errors, DURATION))
  end
  
  -- Words
  for _, word in ipairs(self.words) do
    word:update(dt)
  end
end

--- Display the game on screen.
function Game:draw()
  local w = love.graphics.getWidth() - 2 * 24
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(self.font)
  love.graphics.printf(self.score, 24, 24, w, "left")
  love.graphics.printf(format_timer(self.timer), 24, 24, w, "right")
  
  for _, word in ipairs(self.words) do
    word:draw()
  end
end

--- Handle text input.
-- @char character pressed (as utf-8)
function Game:text_input(char)
  if char:lower() == self.word:get_letter() then
    -- Right letter
    self.score = self.score + RIGHT_BONUS
    self.n_letters = self.n_letters + 1
    if self.word:consume_letter() then
      self:new_word()
      self.n_words = self.n_words + 1
    end
  else
    -- Wrong letter
    self.score = self.score - WRONG_MALUS
    self.n_errors = self.n_errors + 1
    -- TODO: screen shake :P
  end
end

return Game