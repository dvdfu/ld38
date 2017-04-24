local Constants = require 'src.constants'
local Gamestate = require 'modules.hump.gamestate'
local Transition = require 'src.states.transition'
local Music = require 'src.music'

local sprites = {
    backgroundBlur = love.graphics.newImage('res/background_blur.png'),
}

local Finale = {}

function Finale:init()
    Music.init()
    self.transition = Transition()
end

function Finale:enter()
    self.transitioning = false
    self.transition:fadeIn()
end

function Finale:update(dt)
    self.transition:update(dt)
end

function Finale:draw()
    love.graphics.draw(sprites.backgroundBlur, 0, 0)
    love.graphics.draw(sprites.backgroundBlur, 480, 0)

    self.transition:draw()
end

return Finale
