local Class = require 'modules.hump.class'
local Vector = require 'modules.hump.vector'
local Bee = require 'src.objects.bee'
local Constants = require 'src.constants'

local Player = Class.new()

Player.BEE_COUNT = 1
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
    self.objects = objects
    self.cursorTime = 0

    for i = 1, Player.BEE_COUNT do
        self:spawnBee(objects, x + math.random(-50, 50), y + math.random(-50, 50), self)
    end

    self.distance = 0
end

function Player:spawnBee(objects, x, y, player, radius, lag)
    radius = radius or 3 + 2 * math.random()
    lag = lag or 1 + math.random(1, 40) / 100

    table.insert(self.bees, Bee(objects, x, y, radius, lag, player))
end

function Player:update(dt)
    self.distance = math.max(self.distance, self.pos.x)
    self.cursorTime = (self.cursorTime + dt / 200) % 1
    if self:numBees() == 0 then
        return
    end

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

    if self.pos.y < 0 then self.pos.y = 0 end
    if self.pos.y > Constants.GAME_HEIGHT then self.pos.y = Constants.GAME_HEIGHT end
    if self.pos.x > Constants.TOTAL_CHUNKS * Constants.GAME_WIDTH then
        self.pos.x = Constants.TOTAL_CHUNKS * Constants.GAME_WIDTH
    end
    if self.pos.x < self:getDistance() - 200 then self.pos.x = self:getDistance() - 200 end
end

function Player:getPosition()
    return self.pos
end

function Player:getDistance()
    return self.distance
end

function Player:numBees()
    local count = 0
    for k, bee in pairs(self.bees) do
        if bee.dead then
            self.bees[k] = nil
        else
            count = count + 1
        end
    end
    return count
end

function Player:setMouse(pos)
    self.mouse = pos
end

function Player:getMouse()
    return self.mouse
end

function Player:shoot()
    if self:numBees() < 2 then return end
    local bullet_bee
    for k, bee in pairs(self.bees) do
        if bee:isDead() then
            self.bees[k] = nil
        else
            bee:shoot()
            self.bees[k] = nil
            break
        end
    end
end

function Player:draw()
    local point
    if self.usingMouse then
        point = self.mouse
    else
        point = self.pos
    end

    love.graphics.setColor(255, 208, 20)
    local radius = 1 + 2 * math.floor(math.sqrt(7 * self:numBees()))
    for i = 1, radius do
        local time = self.cursorTime + i / radius
        local x = radius * math.cos(time * math.pi * 2)
        local y = radius * math.sin(time * math.pi * 2)
        love.graphics.circle('fill', point.x + x, point.y + y, 1)
    end
    love.graphics.setColor(255, 255, 255)
end

return Player
