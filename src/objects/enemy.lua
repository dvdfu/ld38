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
    SPRITE = love.graphics.newImage('res/raindrop_medium.png'),
    DAMPING = 0.5,
    SCALE = 1,
    LOCKING_DISTANCE = 200,
  },
  HUMMINGBIRD = {
    RADIUS = 8,
    SPEED = 8,
    SPRITE = love.graphics.newImage('res/raindrop_small.png'),
    DAMPING = 0.9,
    SCALE = 1,
    LOCKING_DISTANCE = 300,
  }
}

function Enemy:init(objects, x, y, type, player)
  Object.init(self, objects, x, y)
  self.player = player
  self.type = type
  self.metadata = Enemy.TYPES[self.type]
  self.locked = false
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

function Enemy:update(dt)
  local delta

  if not self.locked then
    delta = self.player:getPosition() - self:getPosition()

    if delta:len() < self.metadata.LOCKING_DISTANCE then
      self.locked = true
      self.delta = self.player:getPosition() - self:getPosition()
    end
  else
    delta = self.delta
  end

  x, y = delta:trimmed(self.metadata.SPEED):unpack()
  self.body:setLinearVelocity(x, y)
end

function Enemy:draw()
  local x, y = self.body:getPosition()
  love.graphics.draw(self.metadata.SPRITE, x, y, 0, self.metadata.SCALE, self.metadata.SCALE, self.metadata.RADIUS, self.metadata.RADIUS)
  love.graphics.circle('line', x, y, self.metadata.RADIUS)
  
  -- if self.locked then love.graphics.setColor(255, 0, 0) end
  -- local px, py = self.player:getPosition():unpack()
  -- love.graphics.line(x, y, px, py)
  -- love.graphics.setColor(255, 255, 255)
end

return Enemy
