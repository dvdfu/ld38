local Class = require 'modules.hump.class'
local Enemy = require 'src.objects.enemy'
local Constants = require 'src.constants'

local Hummingbird = Class.new()
Hummingbird:include(Enemy)

Hummingbird.RADIUS = 8
Hummingbird.SPEED = 8
Hummingbird.SPRITE = love.graphics.newImage('res/raindrop_small.png')
Hummingbird.DAMPING = 0.9
Hummingbird.SCALE = 1
Hummingbird.LOCKING_DISTANCE = 300

function Hummingbird:init(objects, x, y, player)
    Enemy.init(self, objects, x, y, player)
    self:addTag('hummingbird')
end

function Hummingbird:getDamping()
    return Hummingbird.DAMPING
end

function Hummingbird:getRadius()
    return Hummingbird.RADIUS
end

function Hummingbird:getLockingDistance()
    return Hummingbird.LOCKING_DISTANCE
end

function Hummingbird:getSpeed()
    return Hummingbird.SPEED
end


function Hummingbird:draw()
    if Constants.DEBUG then self:debug() end

    local x, y = self.body:getPosition()
    love.graphics.draw(Hummingbird.SPRITE, x, y, 0, Hummingbird.SCALE, Hummingbird.SCALE, Hummingbird.RADIUS, Hummingbird.RADIUS)
end

return Hummingbird
