local Constants = require 'src.constants'
local Gamestate = require 'modules.hump.gamestate'
local Game = require 'src.states.game'
local Transition = require 'src.states.transition'
local Music = require 'src.music'

local sprites = {
    backgroundBlur = love.graphics.newImage('res/background_blur.png'),
}

local Intro = {}

function Intro:init()
    Music.init()
    self.transition = Transition()
end

function Intro:enter()
    self.transition:fadeIn()
end

function Intro:update(dt)
    self.transition:update(dt)
end

function Intro:keypressed(key)
    if key == 'return' then
        self.transition:fadeOut(function()
            Gamestate.switch(Game)
        end)
    end
end

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

    self.transition:draw()
end

return Intro
