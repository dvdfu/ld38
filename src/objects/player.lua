local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Bee = require 'src.objects.bee'

local Player = Class.new()
Player:include(Object)
Player.MOVE_SPEED = 3

function Player:init(world, x, y)
    Object.init(self, world, x, y, 32, 32)

    for i = 1, 40 do
        Bee(world, x + math.random(-50, 50), y + math.random(-50, 50), self)
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

    Object.update(self, dt)
end

function Player:collide(col)
    if col.normal.y ~= 0 then
        self.vel.y = 0
    end

    if col.normal.x ~= 0 then
        self.vel.x = 0
    end
end

function Player:collisionType()
    return 'ignore'
end

function Player:draw() end

return Player
