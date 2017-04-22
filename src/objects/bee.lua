local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'

local Bee = Class.new()
Bee:include(Object)
Bee.MAX_SPEED = 3

local sprite = love.graphics.newImage('res/bee.png')

function Bee:init(world, x, y, player)
    Object.init(self, world, x, y, 8, 8)
    self.player = player
    self.offset = math.random()
end

function Bee:update(dt)
    Object.update(self, dt)
    local delta = self.player:getCenter() - self:getCenter()
    self.vel = (self.vel + delta / 20):trimmed(Bee.MAX_SPEED)
    self.offset = (self.offset + dt / 16) % 1
end

function Bee:collide(col)
end

function Bee:collisionType()
    return 'solid'
end

function Bee:draw()
    local x, y = self:getCenter():unpack()
    love.graphics.draw(sprite, x, y + math.sin(self.offset * math.pi * 2) * 2, 0, 0.7, 0.7, 8, 8)
end

return Bee
