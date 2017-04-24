love.graphics.setLineStyle('rough')
love.graphics.setDefaultFilter('nearest', 'nearest')

math.randomseed(os.time())

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
    end
end

function love.draw()
    love.graphics.scale(2, 2)
    Gamestate.draw()
end
