local Gamestate = require 'modules.hump.gamestate'
local Timer = require 'modules.hump.timer'
local Class = require 'modules.hump.class'
local Constants = require 'src.constants'

local Transition = Class.new()

function Transition:init(props)
    self.timer = Timer.new()
    self.progress = 0
    props = props or {}
    self.props = {
        length = props.length or 60,
        limit = props.limit or 1,
        easeOut = props.easeOut or 'linear',
        easeIn = props.easeIn or 'linear',
    }
end

function Transition:update(dt)
    self.timer:update(dt)
end

function Transition:fadeOut(after)
    self.progress = 0
    self.timer:clear()
    self.timer:tween(self.props.length, self, { progress = self.props.limit }, self.props.easeOut, function()
        -- tweener has small absolute error
        self.progress = self.props.limit
        if after then after() end
    end)
end

function Transition:fadeIn(after)
    self.progress = self.props.limit
    self.timer:clear()
    self.timer:tween(self.props.length, self, { progress = 0 }, self.props.easeIn, function()
        -- tweener has small absolute error
        self.progress = 0
        if after then after() end
    end)
end

function Transition:draw()
    if self.progress == 0 then return end
    love.graphics.setColor(0, 0, 0, self.progress * self.props.limit * 255)
    love.graphics.rectangle('fill', 0, 0, Constants.GAME_WIDTH, Constants.GAME_HEIGHT)
    love.graphics.setColor(255, 255, 255, 255)
end

return Transition
