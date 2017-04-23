local Constants = require 'src.constants'
local Gamestate = require 'modules.hump.gamestate'
local Game = require 'src.states.game'
local Music = require 'src.music'

local sprites = {
    backgroundBlur = love.graphics.newImage('res/background_blur.png'),
}

local Intro = {}

function Intro:init()
    Music.intro()
end

function Intro:enter()
end

function Intro:update(dt)
end

function Intro:keypressed(key)
    if key == 'return' then
        Gamestate.switch(Game)
    end
end

strings = [[
According to all known laws
of aviation,

there is no way a bee
should be able to fly.

Its wings are too small to get
its fat little body off the ground.

The bee, of course, flies anyway

because bees don't care
what humans think is impossible.
]]

function Intro:draw()
    love.graphics.draw(sprites.backgroundBlur, 0, 0)

    love.graphics.setFont(Constants.FONTS.REDALERT)
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf("According to all known laws of aviation,", 0, 30, Constants.GAME_WIDTH, 'center')
    love.graphics.printf("there is no way a bee should be able to fly.", 0, 43, Constants.GAME_WIDTH, 'center')
    love.graphics.printf("Its wings are too small to get its fat little body off the ground.", 0, 69, Constants.GAME_WIDTH, 'center')
    love.graphics.printf("The bee, of course, flies anyway", 0, 95, Constants.GAME_WIDTH, 'center')
    love.graphics.printf("because bees don't care what humans think is impossible.", 0, 108, Constants.GAME_WIDTH, 'center')
    love.graphics.printf("Press ENTER to START!", 0, 130, Constants.GAME_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255)
end

return Intro
