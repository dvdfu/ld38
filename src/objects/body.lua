local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'

local Body = Class.new()

function Body:init(objects, x, y)
    objects:add(self)
    self:build(objects:getWorld(), x, y)
    self.tags = {}
end

function Body:build(...) end

function Body:update(dt) end

function Body:getPosition()
    return Vector(self.body:getPosition())
end

function Body:isDead()
    return self.body:isDestroyed()
end

function Body:addTag(tag)
    self.tags[tag] = true
end

function Body:hasTag(tag)
    return self.tags[tag] == true
end

function Body:draw() end

return Body
