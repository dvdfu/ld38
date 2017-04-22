local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'

local Object = Class.new()

function Object:init(objects, x, y, w, h)
    objects:add(self, x, y, w, h)
    self.objects = objects
    self.pos = Vector(x, y)
    self.size = Vector(w, h)
    self.vel = Vector(0, 0)
    self.dead = false
end

function Object:update(dt)
    self:move(self.vel.x, self.vel.y)
    self.tag = {}
end

function Object:move(dx, dy)
    if dx == 0 and dy == 0 then return end
    local ax, ay, cols, len = self.objects:move(self, self.pos.x + dx, self.pos.y + dy, self.filter)
    for _, col in pairs(cols) do
        self:collide(col)
    end
    self.pos.x = ax
    self.pos.y = ay
end

function Object:canMove(dx, dy)
    local x, y = self.pos.x + dx, self.pos.y + dy
    local ax, ay, cols, len = self.objects:check(self, x, y, self.filter)
    return len == 0 or (ax == x and ay == y)
end

function Object:collide(col) end

function Object:filter(other)
    if self:collisionType() == 'ignore' or other:collisionType() == 'ignore' then return nil end
    if self:collisionType() == 'solid' and other:collisionType() == 'solid' then return 'slide' end
    return 'cross'
end

function Object:collisionType()
    return 'ignore'
end

function Object:isDead()
    return self.dead
end

function Object:getCenter()
    return self.pos + self.size / 2
end

function Object:addTag(tag)
    self.tags[tag] = true
end

function Object:hasTag(tag)
    return self.tags[tag] == true
end

function Object:draw()
    love.graphics.rectangle('line', self.pos.x, self.pos.y, self.size.x, self.size.y)
end

return Object
