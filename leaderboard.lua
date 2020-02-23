local Leaderboard = {}
Leaderboard.__index = Leaderboard

function Leaderboard.new(font, score, n_words, n_letters, n_errors, duration)
  local self = setmetatable(Leaderboard, {})
  
  self.font = font
  self.score = score
  self.n_words = n_words
  self.n_letters = n_letters
  self.n_errors = n_errors
  self.duration = duration
  
  return self
end

function Leaderboard:enter(states)
  self.states = states
end

function Leaderboard:draw()
  -- TODO: real leaderboad, not only stats
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(self.font)
  love.graphics.printf({
    {1, 1, 1, .7}, "Score :\n",
    {1, 1, 1, 1}, self.score,
    {1, 1, 1, .7}, "\n\nNombre de mots :\n",
    {1, 1, 1, 1}, self.n_words,
    {1, 1, 1, .7}, "\nMots par seconde :\n",
    {1, 1, 1, 1}, self.n_words / self.duration,
    {1, 1, 1, .7}, "\n\nNombre de lettres :\n",
    {1, 1, 1, 1}, self.n_letters,
    {1, 1, 1, .7}, "\nLettres par seconde :\n",
    {1, 1, 1, 1}, self.n_letters / self.duration,
    {1, 1, 1, .7}, "\n\nNombre d'erreurs :\n",
    {1, 1, 1, 1}, self.n_errors .. " (" .. self.n_errors / (self.n_letters + self.n_errors) * 100 .. "%)"
  }, 24, 24, love.graphics.getWidth() - 48)
end

function Leaderboard:key_pressed(key)
  if key == "return" then
    -- TODO: fix cyclic dependencies a prettier way :P
    self.states:set(require("start_menu").new(self.font))
  end
end

return Leaderboard
