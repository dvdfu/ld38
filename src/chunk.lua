local Class = require 'modules.hump.class'
local Flower = require 'src.objects.flower'
local Raindrop = require 'src.objects.raindrop'

local Chunk = Class.new()

function Chunk:init(objects, player, id, x, w)
    self.objects = objects
    self.player = player
    self.x = x
    self.w = w
    self.h = love.graphics.getHeight() / 2
    self.raindrops = {}

    if id > 0 then
        local n = 3
        for i = 1, n do
            local x2 = x + ((i - 1) * w / 3) + math.random(100, 200)

            table.insert(objects, Flower(objects, x2, self.h + math.random(0, 50)))
        end

        if math.random() < 1.1 then
            table.insert(self.raindrops, math.random(x, x + w))
        end
    end
end

function Chunk:update(dt)
    for rk, rx in pairs(self.raindrops) do
        if self.player:getPosition().x > rx then
            table.insert(self.objects, Raindrop(self.objects, rx, -100, math.random(0, 36)))
            self.raindrops[rk] = nil
        end
    end
end

return Chunk
