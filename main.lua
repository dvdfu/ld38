love.graphics.setLineStyle('rough')
love.graphics.setDefaultFilter('nearest', 'nearest')

local Bump = require 'modules.bump.bump'

function love.load()
    world = Bump.newWorld()
    objects = {}
end

function love.update(dt)
    for _, object in pairs(objects) do
        object:update(dt)
    end
end

function love.draw()
    for _, object in pairs(objects) do
        object:draw()
    end
end
