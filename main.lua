love.graphics.setLineStyle('rough')
love.graphics.setDefaultFilter('nearest', 'nearest')

local Gamestate = require 'modules.hump.gamestate'
local Intro = require 'src.states.intro'
local Game = require 'src.states.game'
local Constants = require 'src.constants'

function love.load()
    Gamestate.switch(Intro)
end

function love.update(dt)
    dt = 1
    Gamestate.update(dt)
end

function love.keypressed(key)
    Gamestate.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
    elseif key == 'r' then
        Gamestate.switch(Game)
    elseif key == 'e' then
        Constants.DEBUG = not Constants.DEBUG
    end
end

function love.draw()
    love.graphics.scale(2, 2)
    Gamestate.draw()
end
