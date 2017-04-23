local Class = require 'modules.hump.class'
local Flower = require 'src.objects.flower'
local Constants = require 'src.constants'

local Chunk = Class.new()
Chunk.FLOWERS = 2

function Chunk:init(objects, id)
    self.x = id * Constants.GAME_WIDTH
    self.h = Constants.GAME_HEIGHT

    -- spawn some flowers DO THIS BETTER
    if id > 0 then
        for i = 1, Chunk.FLOWERS do
            local fx = (i - math.random()) * Constants.GAME_WIDTH / Chunk.FLOWERS
            table.insert(objects, Flower(objects, self.x + fx, self.h - math.random(20, 80)))
        end
    end
end

function Chunk:update(dt)
    --  spawn things
end

function Chunk:draw()
    if Constants.DEBUG then
        love.graphics.push('all')
            if (self.x / Constants.GAME_WIDTH) % 2 == 0 then
                love.graphics.setColor(52, 152, 219, 50)
            else
                love.graphics.setColor(231, 76, 60, 50)
            end

            love.graphics.rectangle('fill', self.x, 0, Constants.GAME_WIDTH, self.h)
        love.graphics.pop()
    end
end

return Chunk
