local Constants = require 'src.constants'
local Gamestate = require 'modules.hump.gamestate'
local Transition = require 'src.states.transition'
local Music = require 'src.music'

local sprites = {
    backgroundBlur = love.graphics.newImage('res/background_blur.png'),
}

local Dead = {}

function Dead:init()
    Music.init()
    self.transition = Transition()
end

function Dead:enter()
    self.transitioning = false
    self.transition:fadeIn()
end

function Dead:keypressed(key)
    if key == 'escape' then
        local Intro = require 'src.states.intro'
        Gamestate.switch(Intro)
    elseif not self.transitioning and key == 'return' then
        self.transitioning = true
        self.transition:fadeOut(function()
            local Intro = require 'src.states.intro'
            Gamestate.switch(Intro)
        end)
    end
end

function Dead:update(dt)
    self.transition:update(dt)
end

function Dead:draw()
    love.graphics.draw(sprites.backgroundBlur, 0, 0)
    love.graphics.draw(sprites.backgroundBlur, 480, 0)

    self.transition:draw()
end

return Dead
