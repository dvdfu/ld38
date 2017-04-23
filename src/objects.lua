local Class = require 'modules.hump.class'

local Objects = Class.new()

local function beginContact(a, b, coll)
    local objA = a:getUserData()
    local objB = b:getUserData()
    objA:collide(coll, objB)
    objB:collide(coll, objA)
end

local function endContact(a, b, coll) end

local function preSolve(a, b, coll) end

local function postSolve(a, b, coll, normalimpulse, tangentimpulse) end

function Objects:init()
    self.world = love.physics.newWorld(0, 0, true)
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)
    self.objects = {}
end

function Objects:update(dt)
    self.world:update(dt)
    for k, object in pairs(self.objects) do
        if object:isDead() then
            self.objects[k] = nil
        else
            object:update(dt)
        end
    end
end

function Objects:add(object)
    table.insert(self.objects, object)
end

function Objects:getWorld()
    return self.world
end

function Objects:draw()
    for _, object in pairs(self.objects) do
        object:draw()
    end
end

return Objects
