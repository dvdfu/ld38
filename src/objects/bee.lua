local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'

local Bee = Class.new()
Bee:include(Object)

local sprite = love.graphics.newImage('res/bee.png')

function Bee:init(world, x, y, player)
    Object.init(self, world, x, y, 10, 10)
    self.player = player
    self.offset = math.random(0, math.pi * 2)
end

function Bee:update(dt)
    Object.update(self, dt)
    local delta = self.player:getCenter() - self:getCenter()
    self.vel = (self.vel + delta / 20):trimmed(3)
    self.offset = (self.offset + dt / 8) % (math.pi * 2)
end

function Bee:collide(col)
end

function Bee:collisionType()
    return 'solid'
end

function Bee:draw()
    local x, y = self:getCenter():unpack()
    love.graphics.draw(sprite, x, y + math.sin(self.offset) * 4, 0, 0.5, 0.5, 8, 8)
end

return Bee
