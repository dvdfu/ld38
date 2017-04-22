local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'

local Enemy = Class.new()
Enemy:include(Object)

Enemy.TYPES = {
  bird = {
    radius = 15,
    max_speed = 26,
    sprite = love.graphics.newImage('res/raindrop_medium.png'),
  }
}

function Enemy:init(objects, x, y, type, player)
    Object.init(self, objects, x, y)
    self.player = player
    self:addTag('enemy')
    self:build(objects:getWorld(), x, y, type)
end

function Enemy:build(world, x, y, type)
    self.metadata = Enemy.TYPES[type]
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(self.metadata.radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
end


function Enemy:update(dt)
    local delta = self.player:getPosition() - self:getPosition()
    delta = delta:normalized()*self.metadata.max_speed
    print('=====================================================================', delta, delta)
    self.body:applyForce(delta:unpack())
end

function Enemy:draw()
    local x, y = self.body:getPosition()
    love.graphics.circle('line', x, y, self.metadata.radius)
end

return Enemy
