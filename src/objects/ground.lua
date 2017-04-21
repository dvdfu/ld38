local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'

local Ground = Class.new()
Ground:include(Object)

function Ground:init(world, x, y, w, h)
    Object.init(self, world, x, y, w, h)
end

function Ground:collisionType()
    return 'solid'
end

return Ground
