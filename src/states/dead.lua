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
    "Bees are the only insect in the world that make food that humans can eat.",
    "Worker bees live about six weeks in summer, and several months in the winter.",
    "The average bee will make only 1/12th of a teaspoon of honey in its lifetime.",
    "Pollen is needed to feed to the baby bees to help them grow.",
    "Bees have five eyes - two compound eyes and three tiny ocelli eyes.",
}

function Dead:enter()
    self.dead_string = Dead.STRINGS[math.random(#Dead.STRINGS)]
    self.transition = Transition()
    self.transition:fadeIn()
    self.enableInput = false
    self.timer = Timer.new()
    self.state = {
        opacity = 0,
        textPos = Constants.GAME_HEIGHT / 2,
        textOpacity = 0,
        bgScale = 1.0
    }

    self.timer:tween(2000, self.state, { bgScale = 1.5 }, 'linear')

    self.timer:after(200, function()
        self.timer:tween(60, self.state, {
            opacity = 125,
            textPos = Constants.GAME_HEIGHT / 2 - 50,
            textOpacity = 255
        }, 'in-out-cubic', function()
            self.enableInput = true
        end)
    end)
end

function Dead:gotoNextState()
    self.enableInput = false
    self.transition:fadeOut(function()
        local Intro = require 'src.states.intro'
        Gamestate.switch(Intro)
    end)
end

function Dead:keypressed(key)
    if key == 'escape' then
        local Intro = require 'src.states.intro'
        Gamestate.switch(Intro)
    elseif self.enableInput and key == 'return' then
        self:gotoNextState()
    end
end

function Dead:mousepressed()
    if self.enableInput then
        self:gotoNextState()
    end
end

function Dead:update(dt)
    self.transition:update(dt)
    self.timer:update(dt)
end

function Dead:draw()
    love.graphics.draw(sprites.background, Constants.GAME_WIDTH / 2, Constants.GAME_HEIGHT / 2, 0, self.state.bgScale, self.state.bgScale, Constants.GAME_WIDTH / 2, Constants.GAME_HEIGHT / 2)

    love.graphics.setColor(0, 0, 0, self.state.opacity)
    love.graphics.rectangle('fill', 0, 0, Constants.GAME_WIDTH, Constants.GAME_HEIGHT)
    love.graphics.setColor(255, 255, 255, self.state.textOpacity)
    love.graphics.printf(self.dead_string, Constants.GAME_WIDTH / 2 - 100, self.state.textPos, 200, 'center')
    love.graphics.printf("TAP or press ENTER to try again", Constants.GAME_WIDTH / 2 - 100, self.state.textPos + 50, 200, 'center')
    love.graphics.setColor(255, 255, 255)

    self.transition:draw()
end

return Dead
