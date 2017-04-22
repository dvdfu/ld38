local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'

local Object = Class.new()

function Object:init(objects, x, y)
    objects:add(self)
    self:build(objects:getWorld(), x, y)
    self.tags = {}
end

function Object:build(...) end

function Object:update(dt) end

function Object:getPosition()
    return Vector(self.body:getPosition())
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
