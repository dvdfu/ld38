local Gamestate = require 'modules.hump.gamestate'
local Timer = require 'modules.hump.timer'
local Transition = require 'src.states.transition'
local Constants = require 'src.constants'
local Music = require 'src.music'

local sprites = {
    background = love.graphics.newImage('res/ending_swarm.png'),
}

local Finale = {}

function Finale:enter()
    Music.finale()
    self.transition = Transition()
    self.transition:fadeIn()
    self.enableInput = false
    self.timer = Timer.new()
    self.state = {
        opacity = 0,
        textOpacity = 0,
        textPos = Constants.GAME_HEIGHT,
        restartTextPos = Constants.GAME_HEIGHT / 2 - 50,
        bgScale = 1.0
    }

    self.timer:tween(2000, self.state, { bgScale = 1.25 }, 'linear')

    self.timer:after(200, function()
        self.timer:tween(60, self.state, {
            opacity = 125,
            textOpacity = 255,
            textPos = Constants.GAME_HEIGHT - 30
        }, 'in-out-cubic', function()
            self.enableInput = true
        end)
    end)
end

function Finale:gotoNextState()
    self.enableInput = false
    self.transition:fadeOut(function()
        local Intro = require 'src.states.intro'
        Gamestate.switch(Intro)
    end)
end

function Finale:keypressed(key)
    if self.enableInput and (key == 'return' or key == 'escape') then
        self:gotoNextState()
    end
end

function Finale:mousepressed()
    if self.enableInput then
        self:gotoNextState()
    end
end

function Finale:update(dt)
    self.transition:update(dt)
    self.timer:update(dt)
end

function Finale:drawCredits()
    love.graphics.setColor(0, 0, 0, self.state.opacity)
    love.graphics.rectangle('fill', 0, 0, Constants.GAME_WIDTH, Constants.GAME_HEIGHT)

    love.graphics.setColor(255, 255, 255, self.state.textOpacity)

    love.graphics.print("Made by David Fu, Hamdan Javeed, and Seikun Kambashi", 22, self.state.textPos)
    love.graphics.setColor(255, 255, 255)
end

function Finale:draw()
    love.graphics.draw(sprites.background, Constants.GAME_WIDTH / 2, Constants.GAME_HEIGHT / 2, 0, self.state.bgScale, self.state.bgScale, Constants.GAME_WIDTH / 2, Constants.GAME_HEIGHT / 2)


    self:drawCredits()
    self.transition:draw()
end

return Finale
