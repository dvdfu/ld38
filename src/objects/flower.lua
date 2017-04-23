local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'
local Object = require 'src.objects.object'

local Flower = Class.new()
Flower:include(Object)

local sprites = {
    petals = love.graphics.newImage('res/flower_petals.png'),
    stamen = love.graphics.newImage('res/flower_stamen.png'),
    stem = love.graphics.newImage('res/flower_stem.png')
}

-- (x, y) is the point at the bottom of the stem, so the bottom middle of the entire flower
function Flower:init(objects, x, y)
    Object.init(self, objects, x, y)

    self:build(objects:getWorld(), x, y)
    self:addTag('flower')
end

-- the bounding box encompasses the petals
function Flower:build(world, x, y)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newRectangleShape(140, 24)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Flower:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.stem, x, y + 24, 0, 1, 1, 29, 0)
    love.graphics.draw(sprites.petals, x, y, 0, 1, 1, 80, 18)
    love.graphics.draw(sprites.stamen, x, y - 2, 0, 1, 1, 16, 32)
end

return Flower
