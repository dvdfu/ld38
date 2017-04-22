local Class = require 'modules.hump.class'
local Bump = require 'modules.bump.bump'

local Objects = Class.new()

function Objects:init()
    self.world = Bump.newWorld()
    self.objects = {}
end

function Objects:update(dt)
    for k, object in pairs(self.objects) do
        if object:isDead() then
            self.world:remove(object)
            self.objects[k] = nil
        else
            object:update(dt)
        end
    end
end

function Objects:add(object, x, y, w, h)
    self.world:add(object, x, y, w, h)
    table.insert(self.objects, object)
end

function Objects:move(...)
    return self.world:move(...)
end

function Objects:check(...)
    return self.world:check(...)
end

function Objects:draw()
    for _, object in pairs(self.objects) do
        object:draw()
    end
end

return Objects
