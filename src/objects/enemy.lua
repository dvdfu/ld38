local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'
local Vector = require 'modules.hump.vector'
local Timer = require 'modules.hump.timer'

local Enemy = Class.new()
Enemy:include(Object)

Enemy.TYPES = {
  BIRD = {
    RADIUS = 15,
    SPEED = 2,
    REST_X = 300,
    REST_Y = 30,
  }
}

function Enemy:init(objects, x, y, type, player)
  Object.init(self, objects, x, y)
  self.player = player
  self.type = type
  self.attacking = false
  self.target = Vector(Enemy.TYPES[self.type].REST_X, Enemy.TYPES[self.type].REST_Y)
  self:addTag('enemy')
  self:build(objects:getWorld(), x, y)
end

function Enemy:build(world, x, y)
  self.body = love.physics.newBody(world, x, y, 'dynamic')
  self.body:setLinearDamping(0.1, 0.1)
  self.shape = love.physics.newCircleShape(Enemy.TYPES[self.type].RADIUS)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
end


function Enemy:update(dt)
  local delta = (self.target - self:getPosition()):normalized()*Enemy.TYPES[self.type].SPEED

  if not self.attacking then
    if self.timer then
      self.timer:update(dt)
    elseif delta:len() < 1 then
      self.timer = Timer.new()
      self.timer:after(5, function()
        self.attacking = true
        self.target = self.player:getPosition()
      end)
    end

    self.body:applyForce(delta:unpack())
  else
    x, y = delta:unpack()
    self.body:applyForce(-math.abs(x), y)
  end
end

function Enemy:draw()
  local x, y = self.body:getPosition()
  love.graphics.circle('line', x, y, Enemy.TYPES[self.type].RADIUS)
end

return Enemy
