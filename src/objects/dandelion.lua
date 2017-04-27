local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'
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
    self.fixture:setFilterData(0xFFFF, 0xFFFF, -1)
    self.fixture:setDensity(0.1)
    self.fixture:setUserData(self)
end

function Seeds:update(dt)
    Object.update(self, dt)
    self.body:applyForce(0, -1)
end

function Seeds:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.core, x, y, 0, 1, 1, 16, 16)
    love.graphics.draw(sprites.seeds, x, y, 0, self.radius / 36, self.radius / 36, 40, 40)
end

--------------------------------------------------------------------------------

local Dandelion = Class.new()
Dandelion:include(Object)

function Dandelion:init(objects, x, y, height, radius)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self:addTag('dandelion')
    self.height = height
    self.radius = radius
    self.seeds = Seeds(objects, x, y - height, radius)
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

    local x1, y1, x2, y2 = self.rope:getAnchors()
    local root = Vector(x1, y1)
    local seed = Vector(x2, y2)
    love.graphics.setLineWidth(self.radius / 4)
    love.graphics.setColor(135, 156, 107)
    love.graphics.line(seed.x, seed.y, root.x, root.y)
    love.graphics.setColor(91, 119, 86)
    root = seed + (root - seed):trimmed(self.radius + 20)
    love.graphics.line(seed.x, seed.y, root.x, root.y)
    love.graphics.setColor(255, 255, 255)
    
    self.seeds:draw()
end

return Dandelion
