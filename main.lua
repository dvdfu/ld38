love.graphics.setLineStyle('rough')
love.graphics.setDefaultFilter('nearest', 'nearest')

local Gamestate = require 'modules.hump.gamestate'
local Game = require 'src.states.game'

function love.load()
    Gamestate.registerEvents()
    Gamestate.switch(Game)
end

function love.draw()
    love.graphics.scale(2, 2)
end
