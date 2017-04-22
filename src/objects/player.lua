local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'
local Bee = require 'src.objects.bee'

local Player = Class.new()
Player.MOVE_SPEED = 3

function Player:init(objects, x, y)
    self.pos = Vector(x, y)
    self.vel = Vector()

    for i = 1, 50 do
        Bee(objects, x + math.random(-50, 50), y + math.random(-50, 50), self)
    end
end

function Player:update(dt)
    if love.keyboard.isDown('a') then
        self.vel.x = -Player.MOVE_SPEED
    elseif love.keyboard.isDown('d') then
        self.vel.x = Player.MOVE_SPEED
    else
        self.vel.x = 0
    end
    if love.keyboard.isDown('w') then
        self.vel.y = -Player.MOVE_SPEED
    elseif love.keyboard.isDown('s') then
        self.vel.y = Player.MOVE_SPEED
    else
        self.vel.y = 0
    end

    self.pos = self.pos + self.vel * dt
end

function Player:getPosition()
    return self.pos
end

function Player:draw()
    love.graphics.circle('line', self.pos.x, self.pos.y, 16)
end

return Player
