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

    self.petalSize = Vector(sprites.petals:getWidth(), sprites.petals:getHeight())
    self.stemSize = Vector(sprites.stem:getWidth(), sprites.stem:getHeight())
    self.stamenSize = Vector(sprites.stamen:getWidth(), sprites.stamen:getHeight())

    self:build(objects:getWorld(), x, y)
    self:addTag('flower')
end

-- the bounding box encompasses the petals
function Flower:build(world, x, y)
    local xCenter = x - self.petalSize.x / 2
    local yCenter = y - self.stemSize.y - self.petalSize.y / 2
    self.body = love.physics.newBody(world, xCenter, yCenter, 'static')
    self.shape = love.physics.newRectangleShape(xCenter, yCenter, self.petalSize.x, self.petalSize.y)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Flower:update(dt)
end

function Flower:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.stem,   x - self.stemSize.x / 2 + 3, y + self.petalSize.y / 2)
    love.graphics.draw(sprites.petals, x - self.petalSize.x / 2,    y - self.petalSize.y / 2)
    love.graphics.draw(sprites.stamen, x - self.stamenSize.x / 2,   y - self.petalSize.y + 9)
end

return Flower
