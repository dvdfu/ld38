local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Vector = require 'modules.hump.vector'
local Object = require 'src.objects.object'
local Animation = require 'src.animation'

local Raindrop = Class.new()
Raindrop:include(Object)

local sprites = {
    small = love.graphics.newImage('res/raindrop_small.png'),
    medium = love.graphics.newImage('res/raindrop_medium.png'),
    large = love.graphics.newImage('res/raindrop_large.png'),
    splash = love.graphics.newImage('res/raindrop_splash.png'),
}

local sounds = {
    droplet = love.audio.newSource('res/sounds/droplet.wav')
}

function Raindrop:init(objects, x, y, radius)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y, radius)
    self.radius = radius
    self.wobble = 0
    self.dead = false
    self.splash = Animation(sprites.splash, 3, 4)
    self.timer = Timer.new()
    self:addTag('raindrop')
end

function Raindrop:build(world, x, y, radius)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(radius)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Raindrop:update(dt)
    Object.update(self, dt)
    self.body:setLinearVelocity(0, 4)
    self.wobble = (self.wobble + dt / 30) % 1
    self.timer:update(dt)

    if self.dead then
        self.splash:update(dt)
    end
end

function Raindrop:collide(col, other)
    if other:hasTag('flower') or other:hasTag('frog') then
        self:die()
    end
end

function Raindrop:die()
    if self.dead then return end
    self.dead = true
    self.fixture:setSensor()
    sounds.droplet:setPitch(1.2 - self.radius / 60)
    sounds.droplet:play()
    self.timer:after(10, function()
        self.body:destroy()
    end)
end

function Raindrop:draw()
    local x, y = self.pos:unpack()
    local radius = self.radius + 3 -- buffer spaces
    if self.dead then
        self.splash:draw(x, y, 0, radius / 32, radius / 32, 32, 32)
        return
    end

    local wobble = math.sin(self.wobble * math.pi * 2) / 16
    if radius > 16 then
        local scale = radius / 32
        love.graphics.draw(sprites.large, x, y, 0, scale + wobble, scale - wobble, 32, 32)
    elseif radius > 8 then
        local scale = radius / 16
        love.graphics.draw(sprites.medium, x, y, 0, scale + wobble, scale - wobble, 16, 16)
    else
        local scale = radius / 8
        love.graphics.draw(sprites.small, x, y, 0, scale + wobble, scale - wobble, 8, 8)
    end
end

return Raindrop
