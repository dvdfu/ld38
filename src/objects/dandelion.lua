local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Constants = require 'src.constants'

local sprites = {
    petals = love.graphics.newImage('res/flower_petals.png'),
    stamen = love.graphics.newImage('res/flower_stamen.png'),
    stem = love.graphics.newImage('res/flower_stem.png'),
    pollen = love.graphics.newImage('res/flower_pollen.png'),
    splash = love.graphics.newImage('res/droplet.png'),
    dropletSmall = love.graphics.newImage('res/droplet_small.png')
}

local Dandelion = Class.new()
Dandelion:include(Object)

local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Constants = require 'src.constants'


local sprites = {
    seeds = love.graphics.newImage('res/seeds.png'),
}

local Seeds = Class.new()
Seeds:include(Object)

function Seeds:init(objects, x, y)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self:addTag('seeds')
end

function Seeds:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setSleepingAllowed(false)
    self.shape = love.physics.newCircleShape(40)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Seeds:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.seeds, x, y, self.body:getAngle(), 1, 1, 32, 32)
end

function Seeds:update(dt)
    Object.update(self, dt)
    self.body:applyForce(0, -0.5)
end

--------------------------------------------------------------------------------

local Dandelion = Class.new()
Dandelion:include(Object)

function Dandelion:init(objects, x, y)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, Constants.GAME_HEIGHT)
    self:addTag('dandelion')
    self.height = Constants.GAME_HEIGHT - y
    self.seeds = Seeds(objects, x, y)
    local a, b = self.seeds.body:getPosition()
    self.rope = love.physics.newRopeJoint(self.body, self.seeds.body, x, Constants.GAME_HEIGHT, a, b + 30, self.height, true)
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
        love.graphics.setLineWidth(3)
        love.graphics.setColor(178, 219, 151)
        love.graphics.line(x1, y1, x2, y2-2)
    love.graphics.pop()
end

return Dandelion
