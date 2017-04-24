local Gamestate = require 'modules.hump.gamestate'
local Timer = require 'modules.hump.timer'
local Transition = require 'src.states.transition'
local Constants = require 'src.constants'
local Music = require 'src.music'

local sprites = {
    background = love.graphics.newImage('res/ending_death.png'),
}

local Dead = {}

function Dead:enter()
    self.transition = Transition()
    self.transition:fadeIn()
    self.transitioning = false
    self.timer = Timer.new()
    self.state = {
        opacity = 0,
        textPos = Constants.GAME_HEIGHT / 2 + 50,
        textOpacity = 0
    }

    self.timer:after(200, function()
        self.timer:tween(60, self.state, {
            opacity = 125,
            textPos = Constants.GAME_HEIGHT / 2,
            textOpacity = 255
        }, 'in-out-cubic')
    end)
end

function Dead:update(dt)
    self.timer:update(dt)
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
    self.timer:update(dt)
end

function Dead:draw()
    love.graphics.draw(sprites.background, 0, 0)

    love.graphics.setColor(0, 0, 0, self.state.opacity)
    love.graphics.rectangle('fill', 0, 0, Constants.GAME_WIDTH, Constants.GAME_HEIGHT)
    love.graphics.setColor(255, 255, 255, self.state.textOpacity)
    love.graphics.printf("Try again?", Constants.GAME_WIDTH / 2 - 100, self.state.textPos, 200, 'center')
    love.graphics.setColor(255, 255, 255)

    self.transition:draw()
end

return Dead
