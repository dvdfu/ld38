local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'

local Flower = Class.new()
Flower:include(Object)

local sprites = {
    petals = love.graphics.newImage('res/flower_petals.png'),
    stamen = love.graphics.newImage('res/flower_stamen.png'),
    stem = love.graphics.newImage('res/flower_stem.png')
}

function Flower:init(objects, x, y)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self:addTag('flower')
end

function Flower:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'static')
    self.shape = love.physics.newCircleShape(4)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Flower:update(dt)
end

function Flower:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.stem, x - sprites.stem:getWidth() / 2 + 3, y - sprites.stem:getHeight())
    love.graphics.draw(sprites.petals, x - sprites.petals:getWidth() / 2, y - sprites.stem:getHeight() - sprites.petals:getHeight())
    love.graphics.draw(sprites.stamen, x - sprites.stamen:getWidth() / 2, y - sprites.stem:getHeight() - sprites.petals:getHeight() - sprites.stamen:getHeight() + 17)
end

return Flower
