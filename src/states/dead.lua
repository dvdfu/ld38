local Gamestate = require 'modules.hump.gamestate'
local Timer = require 'modules.hump.timer'
local Transition = require 'src.states.transition'
local Constants = require 'src.constants'
local Music = require 'src.music'

local sprites = {
    background = love.graphics.newImage('res/ending_death.png'),
}

local Dead = {}

Dead.STRINGS = {
    "Gone but not forgotten.",
    "The death of one bee is a tradegy, the death of a million is a statistic.",
    "If you encounter enemies, then you're going the right way.",
    "gg",
}

function Dead:enter()
    self.dead_string = Dead.STRINGS[math.random(#Dead.STRINGS)]
    self.transition = Transition()
    self.transition:fadeIn()
    self.enableInput = false
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
        }, 'in-out-cubic', function()
            self.enableInput = true
        end)
    end)
end

function Dead:update(dt)
    self.timer:update(dt)
end

function Dead:keypressed(key)
    if key == 'escape' then
        local Intro = require 'src.states.intro'
        Gamestate.switch(Intro)
    elseif self.enableInput and key == 'return' then
        self.enableInput = false
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
    love.graphics.printf(self.dead_string, Constants.GAME_WIDTH / 2 - 100, self.state.textPos, 200, 'center')
    love.graphics.printf("Press ENTER to try again", Constants.GAME_WIDTH / 2 - 100, self.state.textPos + 50, 200, 'center')
    love.graphics.setColor(255, 255, 255)

    self.transition:draw()
end

return Dead
