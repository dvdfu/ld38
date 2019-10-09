local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Vector = require 'modules.hump.vector'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'
local Constants = require 'src.constants'

local sprites = {
    petals = love.graphics.newImage('res/flower_petals.png'),
    stamen = love.graphics.newImage('res/flower_stamen.png'),
    stem = love.graphics.newImage('res/flower_stem.png'),
    puff = love.graphics.newImage('res/yellow_puff.png'),
    pollen = love.graphics.newImage('res/flower_pollen.png'),
    splash = love.graphics.newImage('res/droplet.png'),
    dropletSmall = love.graphics.newImage('res/droplet_small.png')
}

local sounds = {
    poof = love.audio.newSource('res/sounds/poof.mp3', "stream")
}

local Pollen = Class.new()
Pollen:include(Object)
Pollen.NUM_BEES = 2

function Pollen:init(objects, x, y)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self:addTag('pollen')
    self.puff = Animation(sprites.puff, 8, 4, true)
    self.dead = false
end

function Pollen:build(world, x, y)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newCircleShape(20)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setSensor(true)
    self.fixture:setUserData(self)
    self.fixture:setFilterData(0xFFFF, 0xFFFF, -1)
end

function Pollen:update(dt)
    self.puff:update(dt)
    if self.pollinated and not self.dead then
        self.dead = true
        local x, y = self.pos:unpack()
        Signal.emit('pollinate', x, y, Pollen.NUM_BEES)
    end
end

function Pollen:pollinate()
    if self.pollinated then return false end
    self.pollinated = true
    self.puff:play()
    sounds.poof:play()
    return true
end

function Pollen:draw()
    local x, y = self.pos:unpack()
    self.puff:draw(x, y + 8, 0, 1, 1, 32, 64)
    if self.pollinated then
        love.graphics.draw(sprites.pollen, x, y + 8, 0, 1, 1, 64, 16)
    end
end

local Flower = Class.new()
Flower:include(Object)
Flower.POLLINATION_RADIUS = 100

function Flower:init(objects, x, y)
    Object.init(self, objects, x, y)
    self.shear = math.random()
    self.petalRotation = math.random()

    self:build(objects:getWorld(), x, y)
    self.pollen = Pollen(objects, x, y - 10)
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

    self.droplets = love.graphics.newParticleSystem(sprites.dropletSmall)
    self.droplets:setSizes(0.4, 0)
    self.droplets:setPosition(x, y)
    self.droplets:setAreaSpread('uniform', 70, 4)
    self.droplets:setParticleLifetime(30)
    self.droplets:setLinearAcceleration(0, 0.2)

    self.dripTimer = Timer.new()
    self.dripTimer:every(8, function()
        self.droplets:emit(1)
    end)
end

-- the bounding box encompasses the petals
function Flower:build(world, x, y)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newRectangleShape(118, 20)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.fixture:setFilterData(0xFFFF, 0xFFFF, -1)

    local leftSide = love.physics.newCircleShape(-118 / 2, 0, 20 / 2)
    local rightSide = love.physics.newCircleShape(118 / 2, 0, 20 / 2)
    local leftFixture = love.physics.newFixture(self.body, leftSide)
    leftFixture:setUserData(self)
    leftFixture:setFilterData(0xFFFF, 0xFFFF, -1)
    local rightFixture = love.physics.newFixture(self.body, rightSide)
    rightFixture:setUserData(self)
    rightFixture:setFilterData(0xFFFF, 0xFFFF, -1)
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
    
    self.pollen:draw()
end

return Flower
