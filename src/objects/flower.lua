local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Vector = require 'modules.hump.vector'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'
local Constants = require 'src.constants'

local sprites = {
    petals = love.graphics.newImage('res/flower_petals.png'),
    stamen = love.graphics.newImage('res/flower_stamen.png'),
    stem = love.graphics.newImage('res/flower_stem.png'),
    droplet = love.graphics.newImage('res/droplet.png'),
    puff = love.graphics.newImage('res/yellow_puff.png'),
    pollen = love.graphics.newImage('res/flower_pollen.png'),
}

local Pollen = Class.new()
Pollen:include(Object)

function Pollen:init(objects, x, y)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self:addTag('pollen')
    self.puff = Animation(sprites.puff, 8, 2, true)
end

function Pollen:build(world, x, y)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newCircleShape(20)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setSensor(true)
    self.fixture:setUserData(self)
end

function Pollen:update(dt)
    self.puff:update(dt)
end

function Pollen:pollinate()
    if self.pollinated then return false end
    self.pollinated = true
    self.puff:play()
    return true
end

function Pollen:draw()
    local x, y = self.body:getPosition()
    self.puff:draw(x, y, 0, 1, 1, 32, 64)
    if self.pollinated then
        love.graphics.setColor(255, 255, 255, 128)
        love.graphics.draw(sprites.pollen, x, y + 8, 0, 1, 1, 64, 16)
        love.graphics.setColor(255, 255, 255, 255)
    end
end

local Flower = Class.new()
Flower:include(Object)
Flower.POLLINATION_RADIUS = 100

-- (x, y) is the point at the bottom of the stem, so the bottom middle of the entire flower
function Flower:init(objects, x, y)
    Object.init(self, objects, x, y)
    self.shear = math.random()

    self:build(objects:getWorld(), x, y)
    self.pollen = Pollen(objects, x, y - 10)
    self:addTag('flower')

    self.particles = love.graphics.newParticleSystem(sprites.droplet)
    local quads = {}
    for i = 1, 4 do
        quads[i] = love.graphics.newQuad((i - 1) * 32, 0, 32, 32, 32 * 4, 32)
    end
    self.particles:setQuads(quads)
    self.particles:setPosition(x, y)
    self.particles:setOffset(16, 32)
    self.particles:setParticleLifetime(10)
    self.particles:setAreaSpread('uniform', 70, 4)

    self.timer = Timer.new()
    self.timer:every(10, function()
        self.particles:emit(1)
    end)

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
    self.particles:update(dt)
    self.timer:update(dt)
end

function Flower:draw()
    local x, y = self.body:getPosition()
    local shear = math.sin(self.shear * math.pi * 2) / 10
    local height = Constants.GAME_HEIGHT - y
    love.graphics.draw(sprites.stem, x, y + 24, 0, 1, height / 64, 29, 0)
    love.graphics.draw(sprites.petals, x, y, 0, 1, 1, 80, 18)
    love.graphics.draw(sprites.stamen, x, y - 2, 0, 1, 1, 16, 32, shear)
    love.graphics.draw(self.particles)
end

return Flower
