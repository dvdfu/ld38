local Class = require 'modules.hump.class'
local Signal = require 'modules.hump.signal'
local Vector = require 'modules.hump.vector'
local Bee = require 'src.objects.bee'
local Constants = require 'src.constants'

local Player = Class.new()
Player.BEE_COUNT = 100
Player.MOVE_SPEED = 3

local sprites = {
    cursor = love.graphics.newImage('res/cursor.png')
}

function Player:init(objects, x, y)
    self.pos = Vector(x, y)
    self.vel = Vector()
    self.mouse = Vector()

    self.bees = Player.BEE_COUNT
    for i = 1, Player.BEE_COUNT do
        Bee(objects,
            x + math.random(-50, 50),
            y + math.random(-50, 50),
            3 + 2 * math.random(),
            1 + 1 * math.random(),
            self)
    end

    Signal.register('bee_death', function()
        self.bees = self.bees - 1
    end)
end

function Player:update(dt)
    if love.mouse.isDown(1) then
        local delta = self.mouse - self.pos
        self.pos = self.pos + delta:trimmed(Player.MOVE_SPEED) * dt
    end
end

function Player:getPosition()
    return self.pos
end

function Player:setMouse(pos)
    self.mouse = pos
end

function Player:draw()
    love.graphics.draw(sprites.cursor, self.mouse.x, self.mouse.y, 0, 1, 1, 16, 16)
end

return Player
