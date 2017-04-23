local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'

local Frog = Class.new()
Frog:include(Object)

local sprites = {
    frog = love.graphics.newImage('res/frog.png')
}

function Frog:init(objects, x, y, player)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self.player = player
end

function Frog:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'static')
    self.shape = love.physics.newCircleShape(96)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Frog:update(dt)
end

function Frog:draw()
    local x, y = self:getPosition():unpack()
    love.graphics.draw(sprites.frog, x, y, 0, 1, 1, 128, 120)
end

return Frog
