local Class = require 'modules.hump.class'
local Enemy = require 'src.objects.enemy'
local Constants = require 'src.constants'

local Bird = Class.new()
Bird:include(Enemy)

Bird.RADIUS = 16
Bird.SPEED = 4
Bird.SPRITE = love.graphics.newImage('res/raindrop_medium.png')
Bird.DAMPING = 0.5
Bird.SCALE = 1
Bird.LOCKING_DISTANCE = 200

function Bird:init(objects, x, y, player)
    Enemy.init(self, objects, x, y, player)
    self:addTag('bird')
end

function Bird:getDamping()
    return Bird.DAMPING
end

function Bird:getRadius()
    return Bird.RADIUS
end

function Bird:getLockingDistance()
    return Bird.LOCKING_DISTANCE
end

function Bird:getSpeed()
    return Bird.SPEED
end

function Bird:draw()
    if Constants.DEBUG then self:debug() end

    local x, y = self.body:getPosition()
    love.graphics.draw(Bird.SPRITE, x, y, 0, Bird.SCALE, Bird.SCALE, Bird.RADIUS, Bird.RADIUS)
end

return Bird
