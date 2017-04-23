local Class = require 'modules.hump.class'
local Flower = require 'src.objects.flower'

local Chunk = Class.new()
Chunk.WIDTH = love.graphics.getWidth()

function Chunk:init(objects, id)
    local x = id * Chunk.WIDTH
    local h = love.graphics.getHeight() / 2

    -- spawn some flowers DO THIS BETTER
    if id > 0 then
        local n = 3
        for i = 1, n do
            local fx = x + ((i - 1) * Chunk.WIDTH / 3) + math.random(100, 200)
            table.insert(objects, Flower(objects, fx, h + math.random(0, 50)))
        end
    end
end

function Chunk:update(dt)
    --  spawn things
end

return Chunk
