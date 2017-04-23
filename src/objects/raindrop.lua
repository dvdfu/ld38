local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'

local Raindrop = Class.new()
Raindrop:include(Object)

local sprites = {
    small = love.graphics.newImage('res/raindrop_small.png'),
    medium = love.graphics.newImage('res/raindrop_medium.png'),
    large = love.graphics.newImage('res/raindrop_large.png'),
}

function Raindrop:init(objects, x, y, radius)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y, radius)
    self.radius = radius
    self.wobble = 0
    self:addTag('raindrop')
end

function Raindrop:build(world, x, y, radius)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Raindrop:update(dt)
    self.body:setLinearVelocity(0, 4)
    self.wobble = (self.wobble + dt / 30) % 1
end

function Raindrop:draw()
    local x, y = self.body:getPosition()
    local wobble = math.sin(self.wobble * math.pi * 2) / 16
    if self.radius > 16 then
        local scale = self.radius / 32
        love.graphics.draw(sprites.large, x, y, 0, scale + wobble, scale - wobble, 32, 32)
    elseif self.radius > 8 then
        local scale = self.radius / 16
        love.graphics.draw(sprites.medium, x, y, 0, scale + wobble, scale - wobble, 16, 16)
    else
        local scale = self.radius / 8
        love.graphics.draw(sprites.small, x, y, 0, scale + wobble, scale - wobble, 8, 8)
    end
end

return Raindrop
