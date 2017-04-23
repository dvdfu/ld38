local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'
local Constants = require 'src.constants'

local Bullet = Class.new()
Bullet:include(Object)
Bullet.SPEED = 0.05

local sprites = {
    bee = love.graphics.newImage('res/bee.png'),
    wings = love.graphics.newImage('res/bee_wings.png'),
}

function Bullet:init(objects, x, y, radius)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y, radius)
    self:addTag('bullet')
    self.offset = math.random()
    self.radius = radius
    self.dead = false
    self.timer = Timer.new()

    self.wingAnim = Animation(sprites.wings, 2, 6)
    self.wingAnim:update(math.random() * 6)
end

function Bullet:build(world, x, y, radius)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setSensor(true)
end

function Bullet:update(dt)
    if self.dead then
        self.body:applyForce(0, 0.02)
    else
        self.body:applyForce(Bullet.SPEED, 0)
        -- -- local delta = self.player:getPosition() - self:getPosition()
        -- delta = delta:trimmed(Bullet.MAX_SPEED)
        -- self.body:applyForce(delta:unpack())
        self.offset = (self.offset + dt / 60) % 1
        self.wingAnim:update(dt)
    end
    self.timer:update(dt)
end

function Bullet:collide(col, other)
    if other:hasTag('enemy') then
        self:die(other)
    end
end

function Bullet:die(other)
    if self.dead then return end
    self.dead = true

    self.timer:after(180, function()
        self.body:destroy()
    end)

    if other then
        local delta = (self:getPosition() - other:getPosition()):trimmed(0.1)
        self.body:applyLinearImpulse(delta:unpack())
        Signal.emit('cam_shake', 4)
    end
end

function Bullet:draw()
    if self:isDead() then return end
    local x, y = self.body:getPosition()
    local vx, vy = self.body:getLinearVelocity()
    local direction = vx < 0 and -1 or 1
    local angle = math.atan2(vy, vx * direction)
    local offset = math.sin(self.offset * math.pi * 2) * 2
    self.wingAnim:draw(             x, y + offset, angle, direction * self.radius / 4, self.radius / 4, 4, 4)
    love.graphics.draw(sprites.bee, x, y + offset, angle, direction * self.radius / 4, self.radius / 4, 4, 4)
end

return Bullet
