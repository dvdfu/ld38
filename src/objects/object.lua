local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'

local Object = Class.new()

function Object:init(world, x, y, w, h)
    world:add(self, x, y, w, h)
    self.world = world
    self.pos = Vector(x, y)
    self.size = Vector(w, h)
    self.vel = Vector(0, 0)
end

function Object:update(dt)
    self:move(self.vel.x, self.vel.y)
end

function Object:move(dx, dy)
    if dx == 0 and dy == 0 then return end
    local ax, ay, cols, len = self.world:move(self, self.pos.x + dx, self.pos.y + dy, self.filter)
    for _, col in pairs(cols) do
        self:collide(col)
    end
    self.pos.x = ax
    self.pos.y = ay
end

function Object:canMove(dx, dy)
    local x, y = self.pos.x + dx, self.pos.y + dy
    local ax, ay, cols, len = self.world:check(self, x, y, self.filter)
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

function Object:destroy()
    self.world:remove(self)
end

function Object:draw()
    love.graphics.rectangle('line', self.pos.x, self.pos.y, self.size.x, self.size.y)
end

return Object
