local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Constants = require 'src.constants'

local Dandelion = Class.new()
Dandelion:include(Object)

local sprites = {
    seeds = love.graphics.newImage('res/dandelion_puff.png'),
    core = love.graphics.newImage('res/dandelion_core.png'),
}

local Seeds = Class.new()
Seeds:include(Object)

function Seeds:init(objects, x, y, radius)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y, radius)
    self.radius = radius
    self:addTag('seeds')
end

function Seeds:build(world, x, y, radius)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setSleepingAllowed(false)
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setDensity(0.1)
    self.fixture:setUserData(self)
end

function Seeds:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.core, x, y, 0, 1, 1, 16, 16)
    love.graphics.draw(sprites.seeds, x, y, 0, self.radius / 36, self.radius / 36, 40, 40)
end

function Seeds:update(dt)
    Object.update(self, dt)
    self.body:applyForce(0, -1)
end

--------------------------------------------------------------------------------

local Dandelion = Class.new()
Dandelion:include(Object)

function Dandelion:init(objects, x, y, height)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self:addTag('dandelion')
    self.height = height
    self.seeds = Seeds(objects, x, y - height, math.random(30, 40))
    local a, b = self.seeds.body:getPosition()
    self.rope = love.physics.newRopeJoint(self.body, self.seeds.body, x, y, a, b, self.height, true)
end

function Dandelion:build(world, x, y)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newCircleShape(0)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Dandelion:draw()
    if self.rope:isDestroyed() then return end
    local x, y = self.body:getPosition()

    love.graphics.push('all')
        local x1, y1, x2, y2 = self.rope:getAnchors()
        love.graphics.setLineWidth(9)
        love.graphics.setColor(135, 156, 107)
        love.graphics.line(x1, y1, x2, y2 - 2)
    love.graphics.pop()
end

return Dandelion
