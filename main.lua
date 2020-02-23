local StateMachine = require "state_machine"
local StartMenu = require "start_menu"

local font
local states

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  font = love.graphics.newFont("JMH Typewriter mono.ttf", 48)
  states = StateMachine.new(StartMenu.new(font))
  
  love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
  states:call("update", dt)
end

function love.draw()
  states:call("draw")
end

function love.keypressed(key)
  states:call("key_pressed", key)
end

function love.textinput(text)
  states:call("text_input", text)
end
