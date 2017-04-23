local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'
local Constants = require 'src.constants'

local Bee = Class.new()
Bee:include(Object)
Bee.MAX_SPEED = 4

local sprites = {
    bee = love.graphics.newImage('res/bee.png'),
    wings = love.graphics.newImage('res/bee_wings.png'),
}

function Bee:init(objects, x, y, radius, lag, player)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y, radius)
    self:addTag('bee')
    self.player = player
    self.offset = math.random()
    self.lag = lag
    self.radius = radius
    self.dead = false
    self.timer = Timer.new()

    self.wingAnim = Animation(sprites.wings, 2, 6)
    self.wingAnim:update(math.random() * 6)
end

function Bee:build(world, x, y, radius)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Bee:update(dt)
    if self.dead then
        self.body:applyForce(0, 0.02)
    else
        local delta = self.player:getPosition() - self:getPosition()
        delta = delta:trimmed(Bee.MAX_SPEED) / 100 / self.lag
        self.body:applyForce(delta:unpack())
        self.offset = (self.offset + dt / 60) % 1
        self.wingAnim:update(dt)
    end
    self.timer:update(dt)
end

function Bee:collide(col, other)
    if other:hasTag('raindrop') or other:hasTag('enemy') or other:hasTag('tongue') then
        self:die(other)
    end
end

function Bee:die(other)
    if self.dead then return end
    self.dead = true

    self.timer:after(180, function()
        self.body:destroy()
    end)
    local delta = (self:getPosition() - other:getPosition()):trimmed(0.1)
    self.body:applyLinearImpulse(delta:unpack())
    Signal.emit('cam_shake', 4)
    Signal.emit('bee_death')
end

function Bee:draw()
    if self:isDead() then return end
    local x, y = self.body:getPosition()
    local vx, vy = self.body:getLinearVelocity()
    local direction = vx < 0 and -1 or 1
    local angle = math.atan2(vy, vx * direction)
    local offset = math.sin(self.offset * math.pi * 2) * 2
    self.wingAnim:draw(             x, y + offset, angle, direction * self.radius / 4, self.radius / 4, 4, 4)
    love.graphics.draw(sprites.bee, x, y + offset, angle, direction * self.radius / 4, self.radius / 4, 4, 4)
end

return Bee
