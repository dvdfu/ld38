local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'

local Bee = Class.new()
Bee:include(Object)
Bee.MAX_ACCEL = 0.1
Bee.MAX_SPEED = 3

local sprite = love.graphics.newImage('res/bee.png')

function Bee:init(world, x, y, player)
    Object.init(self, world, x, y, 8, 8)
    self.player = player
    self.offset = math.random()
    self:addTag('bee')
end

function Bee:update(dt)
    Object.update(self, dt)
    local delta = self.player:getCenter() - self:getCenter()
    self.vel = self.vel + (delta / 20):trimmed(Bee.MAX_ACCEL)
    self.vel = self.vel:trimmed(Bee.MAX_SPEED)
    self.offset = (self.offset + dt / 16) % 1
end

function Bee:collide(col)
    if col.other:hasTag('bee') then
        if col.normal.x ~= 0 then
            self.vel.x = 0
        elseif col.normal.y ~= 0 then
            self.vel.y = 0
        end
    end
end

function Bee:collisionType()
    return 'solid'
end

function Bee:draw()
    local x, y = self:getCenter():unpack()
    love.graphics.draw(sprite, x, y + math.sin(self.offset * math.pi * 2) * 2, 0, 0.7, 0.7, 8, 8)
end

return Bee
