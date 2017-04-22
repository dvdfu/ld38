local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'
local Vector = require 'modules.hump.vector'
local Timer = require 'modules.hump.timer'

local Enemy = Class.new()
Enemy:include(Object)

Enemy.TYPES = {
  BIRD = {
    RADIUS = 16,
    SPEED = 4,
    OFFSET_X = 160,
    OFFSET_Y = -30,
    SPRITE = love.graphics.newImage('res/raindrop_medium.png'),
    DAMPING = 0.5,
    SCALE = 1,
  },
  HUMMINGBIRD = {
    RADIUS = 8,
    SPEED = 2,
    OFFSET_X = 160,
    OFFSET_Y = 30,
    SPRITE = love.graphics.newImage('res/raindrop_small.png'),
    DAMPING = 0.9,
    SCALE = 1,
  }
}

function Enemy:init(objects, x, y, type, player, camera)
  Object.init(self, objects, x, y)
  self.player = player
  self.camera = camera
  self.type = type
  self.attacking = false
  self.metadata = Enemy.TYPES[self.type]
  self:addTag('enemy')
  self:build(objects:getWorld(), x, y)
end

function Enemy:build(world, x, y)
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.body:setLinearDamping(self.metadata.DAMPING, self.metadata.DAMPING)
  self.shape = love.physics.newCircleShape(self.metadata.RADIUS)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
end

function Enemy:getRestTarget()
  return self.camera:getPosition() + Vector(self.metadata.OFFSET_X, self.metadata.OFFSET_Y)
end

function Enemy:update(dt)
  if self.attacking then
    x, y = self.delta:unpack()
    self.body:applyForce(-math.abs(x), y)
  else
    local target = self:getRestTarget()

    local delta = (target - self:getPosition()):trimmed(self.metadata.SPEED)
    x, y = delta:unpack()
    self.body:applyForce(x, y)

    if delta:len() < 1 then
      self.attacking = true
      self.delta = (self.player:getPosition() - self:getPosition()):trimmed(self.metadata.SPEED)
    end
  end
end

function Enemy:draw()
  local x, y = self.body:getPosition()
  love.graphics.draw(self.metadata.SPRITE, x, y, 0, self.metadata.SCALE, self.metadata.SCALE, self.metadata.RADIUS, self.metadata.RADIUS)
  love.graphics.circle('line', x, y, self.metadata.RADIUS)
  x, y = self:getRestTarget():unpack()
  love.graphics.circle('line', x, y, self.metadata.RADIUS)
end

return Enemy
