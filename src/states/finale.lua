local Constants = require 'src.constants'
local Gamestate = require 'modules.hump.gamestate'
local Transition = require 'src.states.transition'
local Music = require 'src.music'
local Timer = require 'modules.hump.timer'

local sprites = {
    backgroundBlur = love.graphics.newImage('res/background_blur.png'),
}

local Finale = {}

function Finale:init()
    self.timer = Timer.new()
    self.transition = Transition()
    self.credits = {
        opacity = 0,
        textPos = Constants.GAME_HEIGHT
    }
end

function Finale:enter()
    Music.finale()
    self.transitioning = false
    self.transition:fadeIn()

    self.timer:tween(100, self.credits, { opacity = 125 }, 'in-out-cubic')
    self.timer:after(80, function()
        self.timer:tween(100, self.credits, { textPos = Constants.GAME_HEIGHT - 30 }, 'in-out-cubic')
    end)
end

function Finale:keypressed(key)
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

function Finale:update(dt)
    self.transition:update(dt)
    self.timer:update(dt)
end

function Finale:drawCredits()
    love.graphics.setColor(0, 0, 0, self.credits.opacity)
    love.graphics.rectangle('fill', 0, 0, Constants.GAME_WIDTH, Constants.GAME_HEIGHT)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Made by David Fu, Seikun Kambashi and Hamdan Javeed", 22, self.credits.textPos)
end

function Finale:draw()
    love.graphics.draw(sprites.backgroundBlur, 0, 0)
    love.graphics.draw(sprites.backgroundBlur, 480, 0)

    self:drawCredits()
    self.transition:draw()
end

return Finale
