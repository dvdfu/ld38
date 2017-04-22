local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Vector = require 'modules.hump.vector'

local Camera = Class.new()
Camera.HALF_SCREEN = Vector(720, 480) / 4

function Camera:init(target, settings)
    settings = settings or {}
    self.damping = settings.damping or 1
    self.buffer = settings.buffer or Vector()

    self.target = target
    self.pos = Vector()
    self.timer = Timer.new()
    self.shakeVec = Vector()
end

function Camera:update(dt)
    self.timer:update(dt)

    local delta = self.target.pos + self.target.size / 2 - self.pos

    -- camera movement buffer
    if delta.x > self.buffer.x then
        delta.x = delta.x - self.buffer.x
    elseif delta.x < -self.buffer.x then
        delta.x = delta.x + self.buffer.x
    else
        delta.x = 0
    end

    if delta.y > self.buffer.y then
        delta.y = delta.y - self.buffer.y
    elseif delta.y < -self.buffer.y then
        delta.y = delta.y + self.buffer.y
    else
        delta.y = 0
    end

    -- damp camera movement if non-trivial
    if delta:len2() > 0.1 then
        delta = delta / self.damping
    end

    self.pos = self.pos + delta * dt
    self.pos.y = 240 -- just for us!
end

function Camera:follow(target)
    self.target = target
end

function Camera:shake(shake, direction)
    shake = shake or 4
    direction = direction or math.random(math.pi * 2)
    self.shakeVec = self.shakeVec + Vector(shake, 0):rotated(-direction)
    self.timer:clear()
    self.timer:tween(30, self.shakeVec, {
        x = 0,
        y = 0
    }, 'out-elastic')
end

function Camera:getPosition()
    return self.pos + self.shakeVec
end

function Camera:draw(callback)
    local translation = Camera.HALF_SCREEN - self:getPosition()

    love.graphics.push()
    love.graphics.translate(translation.x, translation.y)
    callback()
    love.graphics.pop()
end

return Camera
