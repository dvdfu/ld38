local Class = require 'modules.hump.class'
local Enemy = require 'src.objects.enemy'
local Timer = require 'modules.hump.timer'
local Animation = require 'src.animation'
local Constants = require 'src.constants'

local Fly = Class.new()
Fly:include(Enemy)

Fly.RADIUS = 24
Fly.SPEED = 6
Fly.DAMPING = 0.9
Fly.LOCKING_DISTANCE = 200
Fly.PASSIVE_DISTANCE = 500

local sprites = {
    body = love.graphics.newImage('res/fly_body.png'),
    wings = love.graphics.newImage('res/fly_wings.png'),
    legs = love.graphics.newImage('res/fly_legs.png'),
}

function Fly:init(objects, x, y, player)
    Enemy.init(self, objects, x, y, player)
    self:addTag('fly')
    self.wings = Animation(sprites.wings, 2, 1)
    self.time = 0
    self.timer = Timer.new()
end

function Fly:update(dt)
    self.timer:update(dt)
    self.wings:update(dt)
    self.time = (self.time + dt / 30) % 1
    Enemy.update(self, dt)
end

function Fly:getDamping()
    return Fly.DAMPING
end

function Fly:getRadius()
    return Fly.RADIUS
end

function Fly:getLockingDistance()
    return Fly.LOCKING_DISTANCE
end

function Fly:getSpeed()
    return Fly.SPEED
end

function Fly:getPassiveDistance()
    return Fly.PASSIVE_DISTANCE
end


function Fly:collide(col, other)
    if other:hasTag('bullet') then
        self:die(other)
    end
end

function Fly:die(other)
    if self.dead then return end
    self.dead = true

    self.body:destroy()
end


function Fly:draw()
    if self:isDead() then return end

    local x, y = self.body:getPosition()
    local time = math.sin(self.time * math.pi * 2)
    y = y + 10 * time
    self.wings:draw(x - 4, y - 12, 0, -1, 1, 0, 24)
    love.graphics.draw(sprites.body, x, y, 0, 1, 1, 32, 36)
    self.wings:draw(x + 10, y - 12, 0, 1, 1, 0, 24)
    love.graphics.draw(sprites.legs, x, y - 4, 0, 1, 1, 32, 0, time / 10)
    if Constants.DEBUG then self:debug() end
end

return Fly
