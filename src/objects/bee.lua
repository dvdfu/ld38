local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'
local Constants = require 'src.constants'

local Bee = Class.new()
Bee:include(Object)
Bee.MAX_ACCEL = 0.1
Bee.MAX_SPEED = 4

local sprites = {
    bee = love.graphics.newImage('res/bee.png'),
    wings = love.graphics.newImage('res/bee_wings.png'),
}

function Bee:init(objects, x, y, player)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self.player = player
    self.offset = math.random()
    self.lag = 1 + math.random()
    self.dead = false

    self.wingAnim = Animation(sprites.wings, 2, 6)
    self.wingAnim:update(math.random() * 6)
end

function Bee:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(4)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(1)
    self.fixture:setUserData(self)
end

function Bee:update(dt)
    if self.dead then
        self.body:applyForce(0, 0.05)
        if self.body:getY() > Constants.GAME_HEIGHT then
            self.body:destroy()
        end
    else
        local delta = self.player:getPosition() - self:getPosition()
        delta = delta:trimmed(Bee.MAX_SPEED) / 100 / self.lag
        self.body:applyForce(delta:unpack())
        self.offset = (self.offset + dt / 60) % 1
        self.wingAnim:update(dt)
    end
end

function Bee:collide(col, other)
    if other:hasTag('raindrop') then
        self:die(other)
    end
end

function Bee:die(other)
    if self.dead then return end
    self.dead = true

    self.fixture:setSensor(true)
    local delta = (self:getPosition() - other:getPosition()):trimmed(0.1)
    self.body:applyLinearImpulse(delta:unpack())
end

function Bee:draw()
    if self:isDead() then return end
    local x, y = self.body:getPosition()
    local vx, vy = self.body:getLinearVelocity()
    local angle = math.atan2(vy, vx)
    local offset = math.sin(self.offset * math.pi * 2) * 2
    self.wingAnim:draw(x, y + offset, angle, 1, 1, 4, 4)
    love.graphics.draw(sprites.bee, x, y + offset, angle, 1, 1, 4, 4)
end

return Bee
