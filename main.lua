love.graphics.setLineStyle('rough')
love.graphics.setDefaultFilter('nearest', 'nearest')

math.randomseed(os.time())

local Gamestate = require 'modules.hump.gamestate'
local Intro = require 'src.states.intro'
local Music = require 'src.music'

function love.load()
    Gamestate.switch(Intro)
end

function love.update(dt)
    dt = 1
    Gamestate.update(dt)
end

function love.mousepressed(x, y, button, isTouch)
    Gamestate.mousepressed(x, y, button, isTouch)
end

function love.keypressed(key)
    Gamestate.keypressed(key)
    if key == '-' then
        Music.volume_down()
    elseif key == '=' then
        Music.volume_up()
    end
end

function love.draw()
    love.graphics.scale(2, 2)
    Gamestate.draw()
end
