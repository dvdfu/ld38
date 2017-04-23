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
    self.usingMouse = true

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
        self.usingMouse = true
        local delta = self.mouse - self.pos
        self.pos = self.pos + delta:trimmed(Player.MOVE_SPEED) * dt
    else
        if love.keyboard.isDown('a') then
            self.usingMouse = false
            self.vel.x = -Player.MOVE_SPEED
        elseif love.keyboard.isDown('d') then
            self.usingMouse = false
            self.vel.x = Player.MOVE_SPEED
        else
            self.vel.x = 0
        end
        if love.keyboard.isDown('w') then
            self.usingMouse = false
            self.vel.y = -Player.MOVE_SPEED
        elseif love.keyboard.isDown('s') then
            self.usingMouse = false
            self.vel.y = Player.MOVE_SPEED
        else
            self.vel.y = 0
        end
        self.pos = self.pos + self.vel * dt
    end
end

function Player:getPosition()
    return self.pos
end

function Player:setMouse(pos)
    self.mouse = pos
end

function Player:draw()
    if self.usingMouse then
        love.graphics.draw(sprites.cursor, self.mouse.x, self.mouse.y, 0, 1, 1, 16, 16)
    else
        love.graphics.draw(sprites.cursor, self.pos.x, self.pos.y, 0, 1, 1, 16, 16)
    end
end

return Player
