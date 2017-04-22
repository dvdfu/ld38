local Class = require 'modules.hump.class'
local Constants = require 'src.constants'

local Rain = Class.new()

function Rain:init()
    self.drops = {}
end

function Rain:update(dt)
    for k, drop in pairs(self.drops) do
        drop.x = drop.x - drop.depth / 5 * dt
        drop.y = drop.y + drop.depth * 3 * dt
        if drop.y > Constants.GAME_HEIGHT + 30 then
            self.drops[k] = nil
        end
    end
end

function Rain:add(x)
    local drop = {
        x = x,
        y = 0,
        depth = 3 + 7 * math.random()
    }
    table.insert(self.drops, drop)
end

function Rain:draw()
    love.graphics.setColor(80, 120, 160)
    for _, drop in pairs(self.drops) do
        local alpha = 255 - (drop.depth / 10) * 80
        alpha = alpha * (Constants.GAME_HEIGHT - drop.y) / Constants.GAME_HEIGHT
        love.graphics.setColor(255, 255, 255, alpha)
        love.graphics.setLineWidth(drop.depth / 6)
        love.graphics.line(drop.x, drop.y, drop.x + drop.depth / 5, drop.y - drop.depth * 3)
    end
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setLineWidth(1)
end

return Rain
