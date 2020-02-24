local json = require "json"

local Leaderboard = {}
Leaderboard.__index = Leaderboard

--- Convert a float to a readable format (2 decimals only).
-- @param x the float to convert
-- @return a formatted string
local function format_float(x)
  return string.format("%.2f", x)
end

--- Create a new Leaderboard state.
-- @param font the font used to display text
-- @param name the name of the player
-- @param score score of the player
-- @param n_words number of words completed during the game
-- @param n_letters number of letters completed during the game
-- @param n_errors number of errors duting the game
-- @param duration duration of the game (in seconds)
function Leaderboard.new(font, name, score, n_words, n_letters, n_errors, duration)
  local self = setmetatable(Leaderboard, {})
  
  self.font = font
  self.name = name
  self.score = score
  self.n_words = n_words
  self.n_letters = n_letters
  self.n_errors = n_errors
  self.duration = duration
  self.showing_stats = true
  
  -- Load scores from file
  if love.filesystem.getInfo("scores.json") then
    self.scores = json.decode(assert(love.filesystem.read("scores.json")))
  else
    self.scores = {}
  end
  
  -- Add score in the table
  -- It must stay sorted
  local i = 0
  repeat i = i + 1 until i > #self.scores or score > self.scores[i].score
  table.insert(self.scores, i, {
    name = name,
    score = score,
    n_words = n_words,
    n_letters = n_letters,
    n_errors = n_errors
  })
  
  return self
end

--- Callback when entering the state.
-- @param states state machine containing the state
function Leaderboard:enter(states)
  self.states = states
end

--- Callback when leaving the state.
function Leaderboard:leave()
  assert(love.filesystem.write("scores.json", json.encode(self.scores)))
end

--- Display the state on screen.
function Leaderboard:draw()
  local w = math.min(1000, love.graphics.getWidth() - 48) -- width
  local p = math.max(24, (love.graphics.getWidth() - w) / 2) -- padding
  local left, right
  
  love.graphics.setFont(self.font)
  
  if self.showing_stats then
    left = "Score :\n\n" ..
      "Mots :\nMots/Seconde :\n\n" ..
      "Lettres :\nLettres/Seconde :\n\n" ..
      "Erreurs : "
    right = self.score .. "\n\n" ..
      self.n_words .. "\n" .. format_float(self.n_words / self.duration) .. "\n\n" ..
      self.n_letters .. "\n" .. format_float(self.n_letters / self.duration) .. "\n\n" ..
      self.n_errors .. " (" .. format_float(self.n_errors / (self.n_letters + self.n_errors) * 100) .. "%)"
  else -- showing highscores
    left, right = "", ""
    for _, score in ipairs(self.scores) do
      left = left .. score.name .. "\n"
      right = right .. score.score .. "\n"
    end
  end
  
  love.graphics.setColor(1, 1, 1, .7)
  love.graphics.printf(left, p, 24, w)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.printf(right, p, 24, w, "right")
end

--- Handle key pressed.
-- @param key the key pressed
function Leaderboard:key_pressed(key)
  if key == "return" then
    if self.showing_stats then
      self.showing_stats = false
    else
      -- TODO: fix cyclic dependencies a prettier way :P
      self.states:set(require("start_menu").new(self.font))
    end
  end
end

return Leaderboard
