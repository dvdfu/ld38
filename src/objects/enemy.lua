local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'

local Enemy = Class.new()
Enemy:include(Object)

function Enemy:init(objects, x, y, player)
    Object.init(self, objects, x, y)
    self.player = player
    self.locked = false
    self.passive = true
    self:addTag('enemy')
    self:build(objects:getWorld(), x, y)
end

function Enemy:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(self:getDamping(), self:getDamping())
    self.shape = love.physics.newCircleShape(self:getRadius())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Enemy:update(dt)
    local delta

    if not self.locked then
        delta = self.player:getPosition() - self:getPosition()

        if delta:len() > self:getPassiveDistance() then return
        elseif self.passive then self.passive = false end

        if delta:len() < self:getLockingDistance() then
            self.locked = true
            self.delta = self.player:getPosition() - self:getPosition()
        end
    else
        delta = self.delta
    end

    x, y = delta:trimmed(self:getSpeed()):unpack()
    self.body:setLinearVelocity(x, y)
end

function Enemy:debug()
    local x, y = self.body:getPosition()
    local px, py = self.player:getPosition():unpack()

    love.graphics.circle('line', x, y, self:getRadius())

    if not self.locked then love.graphics.setColor(255, 0, 0) end
    if self.passive then love.graphics.setColor(0, 0, 255) end

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
