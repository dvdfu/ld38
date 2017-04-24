local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Vector = require 'modules.hump.vector'
local Constants = require 'src.constants'

local Camera = Class.new()
Camera.HALF_SCREEN = Vector(Constants.GAME_WIDTH, Constants.GAME_HEIGHT) / 2

function Camera:init(x, y, damping)
    self.damping = damping or 1
    self.target = Vector(x, y)
    self.pos = Vector(x, y)
    self.timer = Timer.new()
    self.shakeVec = Vector()
end

function Camera:update(dt)
    self.timer:update(dt)

    local dx = self.target.x - self.pos.x
    if dx > 0.1 then
        -- damp camera movement if non-trivial
        dx = dx / self.damping
    end

    self.pos.x = self.pos.x + dx * dt
end

function Camera:follow(x)
    if x > self.target.x and x < (Constants.TOTAL_CHUNKS) * Constants.GAME_WIDTH - Constants.GAME_WIDTH / 2 then
        self.target.x = x
    end
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
