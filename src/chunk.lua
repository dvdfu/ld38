local Class = require 'modules.hump.class'
local Flower = require 'src.objects.flower'
local Constants = require 'src.constants'

local Chunk = Class.new()
Chunk.FLOWERS = 2

function Chunk:init(objects, id)
    local x = id * Constants.GAME_WIDTH
    local h = Constants.GAME_HEIGHT

    -- spawn some flowers DO THIS BETTER
    if id > 0 then
        for i = 1, Chunk.FLOWERS do
            local fx = (i - math.random()) * Constants.GAME_WIDTH / Chunk.FLOWERS
            table.insert(objects, Flower(objects, x + fx, h - math.random(20, 80)))
        end
    end
end

function Chunk:update(dt)
    --  spawn things
end

return Chunk
