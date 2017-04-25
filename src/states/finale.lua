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
        textPos = Constants.GAME_HEIGHT,
        bgScale = 1.0
    }

    self.timer:tween(200, self.state, { bgScale = 1.5 }, 'linear')

    self.timer:after(200, function()
        self.timer:tween(60, self.state, {
            opacity = 125,
            textPos = Constants.GAME_HEIGHT - 30
        }, 'in-out-cubic', function()
            self.enableInput = true
        end)
    end)
end

function Finale:keypressed(key)
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

function Finale:update(dt)
    self.transition:update(dt)
    self.timer:update(dt)
end

function Finale:drawCredits()
    love.graphics.setColor(0, 0, 0, self.state.opacity)
    love.graphics.rectangle('fill', 0, 0, Constants.GAME_WIDTH, Constants.GAME_HEIGHT)

    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Made by David Fu, Seikun Kambashi and Hamdan Javeed", 22, self.state.textPos)
end

function Finale:draw()
    love.graphics.draw(sprites.background, Constants.GAME_WIDTH / 2, Constants.GAME_HEIGHT / 2, 0, self.state.bgScale, self.state.bgScale, Constants.GAME_WIDTH / 2, Constants.GAME_HEIGHT / 2)


    self:drawCredits()
    self.transition:draw()
end

return Finale
