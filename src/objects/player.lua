local Class = require 'modules.hump.class'
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
    self.bees = {}

    for i = 1, Player.BEE_COUNT do
        self.bees[i] = Bee(objects,
            x + math.random(-50, 50),
            y + math.random(-50, 50),
            3 + 2 * math.random(),
            1 + 1 * math.random(),
            self)
    end

    self.distance = 0
end

function Player:numBees()
    local count = 0
    for k, bee in pairs(self.bees) do
        if bee:isDead() then
            self.bees[k] = nil
        else
            count = count + 1
        end
    end
    return count
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

    self.distance = math.max(self.distance, self.pos.x)
end

function Player:getPosition()
    return self.pos
end

function Player:getDistance()
    return self.distance
end

function Player:getBees()
    return self.bees
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
