local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Vector = require 'modules.hump.vector'
local Object = require 'src.objects.object'
local Constants = require 'src.constants'

local Flower = Class.new()
Flower:include(Object)

Flower.POLLINATION_RADIUS = 100

local sprites = {
    petals = love.graphics.newImage('res/flower_petals.png'),
    stamen = love.graphics.newImage('res/flower_stamen.png'),
    stem = love.graphics.newImage('res/flower_stem.png'),
    splash = love.graphics.newImage('res/droplet.png'),
    droplet_small = love.graphics.newImage('res/droplet_small.png')
}

-- (x, y) is the point at the bottom of the stem, so the bottom middle of the entire flower
function Flower:init(objects, x, y)
    Object.init(self, objects, x, y)
    self.shear = math.random()
    self.petalRotation = math.random()

    self:build(objects:getWorld(), x, y)
    self:addTag('flower')

    self.splashes = love.graphics.newParticleSystem(sprites.splash)
    local quads = {}
    for i = 1, 4 do
        quads[i] = love.graphics.newQuad((i - 1) * 32, 0, 32, 32, 32 * 4, 32)
    end
    self.splashes:setQuads(quads)
    self.splashes:setPosition(x, y)
    self.splashes:setOffset(16, 32)
    self.splashes:setParticleLifetime(10)
    self.splashes:setAreaSpread('uniform', 70, 4)

    self.timer = Timer.new()
    self.timer:every(10, function()
        self.splashes:emit(1)
    end)

    self.droplets = love.graphics.newParticleSystem(sprites.droplet_small)
    self.droplets:setSizes(0.4, 0)
    -- self.droplets:setPosition(x - 75, y - 3)
    self.droplets:setPosition(x, y)
    self.droplets:setAreaSpread('uniform', 70, 4)
    self.droplets:setParticleLifetime(30)
    self.droplets:setLinearAcceleration(0, 0.2)

    self.dripTimer = Timer.new()
    self:drip()

    self.pollinated = false
    self.numBees = math.random(4, 6)
end

-- the bounding box encompasses the petals
function Flower:build(world, x, y)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newRectangleShape(118, 20)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)

    local leftSide = love.physics.newCircleShape(-118 / 2, 0, 20 / 2)
    local rightSide = love.physics.newCircleShape(118 / 2, 0, 20 / 2)
    love.physics.newFixture(self.body, leftSide):setUserData(self)
    love.physics.newFixture(self.body, rightSide):setUserData(self)
end

function Flower:update(dt)
    Object.update(self, dt)
    self.shear = (self.shear + dt / 60) % 1
    self.petalRotation = (self.petalRotation + dt / 120) % 1
    self.splashes:update(dt)
    self.droplets:update(dt)
    self.timer:update(dt)
    self.dripTimer:update(dt)
end

function Flower:drip()
    self.dripTimer:every(math.random(100, 200), function()
        self.dripTimer:after(math.random(1, 100), function()
            self.droplets:emit(1)
        end)
    end)
end

function Flower:draw()
    local x, y = self.body:getPosition()
    local shear = math.sin(self.shear * math.pi * 2) / 10
    local petalRotation = math.sin(self.petalRotation * math.pi * 2) / 40
    local height = Constants.GAME_HEIGHT - y
    love.graphics.draw(sprites.stem, x, y + 24, 0, 1, height / 64, 29, 0)
    love.graphics.draw(self.droplets)
    love.graphics.draw(sprites.petals, x, y, petalRotation, 1, 1, 80, 18, petalRotation)
    love.graphics.draw(sprites.stamen, x, y - 2, 0, 1, 1, 16, 32, shear)
    love.graphics.draw(self.splashes)
end

return Flower
