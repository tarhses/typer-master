local Timer = require "hump.timer"
local StateMachine = require "state_machine"
local StartMenu = require "start_menu"

local font
local states

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  font = love.graphics.newFont("assets/ELEGANT TYPEWRITER.ttf", 54)
  states = StateMachine(StartMenu(font))
  
  love.keyboard.setKeyRepeat(true)
end

function love.quit()
  states:call("leave")
end

function love.update(dt)
  states:call("update", dt)
  Timer.update(dt)
end

function love.draw()
  states:call("draw")
end

function love.keypressed(key)
  states:call("key_pressed", key)
  
  if key == "f11" then
    love.window.setFullscreen(not love.window.getFullscreen())
  end
end

function love.textinput(text)
  states:call("text_input", text)
end
