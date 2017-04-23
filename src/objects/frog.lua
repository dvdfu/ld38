local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Object = require 'src.objects.object'

local sprites = {
    frog = love.graphics.newImage('res/frog.png'),
    mouth = love.graphics.newImage('res/frog_mouth.png'),
    tongue = love.graphics.newImage('res/frog_tongue.png'),
    tongueTip = love.graphics.newImage('res/frog_tongue_tip.png'),
}

local Tongue = Class.new()
Tongue:include(Object)

function Tongue:init(objects, x, y, frog)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self.frog = frog
    self:addTag('tongue')
    self.timer = Timer.new()
end

function Tongue:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(24)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Tongue:update(dt)
    local delta = self.frog:getPosition() - self:getPosition()
    delta = delta:trimmed(2)
    self.body:applyForce(delta:unpack())
    self.timer:update(dt)
end

function Tongue:shoot(pos)
    local delta = pos - self:getPosition()
    delta = delta:normalized() * 80
    self.body:applyLinearImpulse(delta:unpack())
    self.timer:after(120, function()
        self.frog:resetAttack()
    end)
end

--------------------------------------------------------------------------------

local Frog = Class.new()
Frog:include(Object)

function Frog:init(objects, x, y, player)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self.player = player
    self.tongue = Tongue(objects, x, y, self)
    self.joint = love.physics.newRopeJoint(self.body, self.tongue.body, 0, 0, 0, 0, 200, false)
    
    self:addTag('frog')
    self.attacked = false
end

function Frog:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'static')
    self.shape = love.physics.newCircleShape(96)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)

    local leftEye = love.physics.newCircleShape(-84, -55, 28)
    local rightEye = love.physics.newCircleShape(84, -55, 28)
    love.physics.newFixture(self.body, leftEye):setUserData(self)
    love.physics.newFixture(self.body, rightEye):setUserData(self)
end

function Frog:update(dt)
    if not self.attacked then
        local delta = self.player:getPosition() - self:getPosition()
        if math.abs(delta.x) < 120 and delta.y < 0 then
            self.attacked = true
            self.tongue:shoot(self.player:getPosition())
        end
    end
end

function Frog:resetAttack()
    self.attacked = false
end

function Frog:draw()
    local x, y = self:getPosition():unpack()
    local tongue = self.tongue:getPosition()
    local delta = tongue - self:getPosition()
    love.graphics.draw(sprites.frog, x, y - math.min(0, delta.y / 64), 0, 1, 1, 128, 120)

    love.graphics.draw(sprites.tongue, x, y, math.atan2(delta.y, delta.x), delta:len() / 32, 1, 0, 16)
    love.graphics.draw(sprites.tongueTip, tongue.x, tongue.y, 0, 1.5, 1.5, 16, 16)

    love.graphics.draw(sprites.mouth, x, y - math.min(0, delta.y / 4), 0, 1, 1, 80, 80)
end

return Frog
