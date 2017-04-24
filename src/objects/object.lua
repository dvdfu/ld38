local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'

local Object = Class.new()

function Object:init(objects, x, y)
    objects:add(self)
    self.tags = {}
    self.pos = Vector(x, y)
end

function Object:update(dt)
    local x, y = self.body:getPosition()
    self.pos = Vector(x, y)
end

function Object:collide(col, other)
end

function Object:getPosition()
    return self.pos
end

function Object:isDead()
    return self.body:isDestroyed()
end

function Object:addTag(tag)
    self.tags[tag] = true
end

function Object:hasTag(tag)
    return self.tags[tag] == true
end

function Object:draw() end

return Object
