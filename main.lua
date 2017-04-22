love.graphics.setLineStyle('rough')
love.graphics.setDefaultFilter('nearest', 'nearest')

local Gamestate = require 'modules.hump.gamestate'
local Game = require 'src.states.game'

function love.load()
    Gamestate.switch(Game)
end

function love.update(dt)
    dt = 1
    Gamestate.update(dt)
end

function love.draw()
    love.graphics.scale(2, 2)
    Gamestate.draw()
end
