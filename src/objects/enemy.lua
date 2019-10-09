local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Constants = require 'src.constants'

local Enemy = Class.new()
Enemy:include(Object)

local sounds = {
    buzz = love.audio.newSource('res/sounds/fly.mp3', "stream")
}

function Enemy:init(objects, x, y, player)
    Object.init(self, objects, x, y)
    self.player = player
    self.state = 'passive'
    self:addTag('enemy')
    self:build(objects:getWorld(), x, y)
end

function Enemy:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(self:getDamping(), self:getDamping())
    self.shape = love.physics.newCircleShape(self:getRadius())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setFilterData(0xFFFF, 0xFFFF, -1)
end

function Enemy:update(dt)
    Object.update(self, dt)
    local delta
    delta = self.player:getPosition() - self:getPosition()

    if self.state == 'passive' then
        if delta:len() > self:getPassiveDistance() then return end

        self.state = 'attacking'

    elseif self.state == 'attacking' then
        if delta:len() < self:getLockingDistance() then
            self.state = 'locked'
            self.delta = delta
            sounds.buzz:play()
        end
    elseif self.state == 'locked' then
        delta = self.delta
    end

    x, y = delta:trimmed(self:getSpeed()):unpack()
    self.body:setLinearVelocity(x, y)
end

function Enemy:debug()
    local x, y = self.body:getPosition()
    local px, py = self.player:getPosition():unpack()

    love.graphics.circle('line', x, y, self:getRadius())

    if self.state == 'passive' then love.graphics.setColor(0, 0, 255) end
    if self.state == 'attacking' then love.graphics.setColor(255, 0, 0) end

    love.graphics.line(x, y, px, py)
    love.graphics.setColor(255, 255, 255)
end

-- Need to be implemented by subclass.
function Enemy:getDamping() end
function Enemy:getRadius() end
function Enemy:getLockingDistance() end
function Enemy:getSpeed() end
function Enemy:getPassiveDistance() end

return Enemy
