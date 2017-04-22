local Vector = require 'modules.hump.camera'
local Timer = require 'modules.hump.timer'
local Player = require 'src.objects.player'
local Raindrop = require 'src.objects.raindrop'
local Enemy = require 'src.objects.enemy'
local Camera = require 'src.camera'
local Objects = require 'src.objects'

local Game = {}

local sprites = {
    backgroundBlur = love.graphics.newImage('res/background_blur.png'),
}

function Game:enter()
    self.objects = Objects()
    self.player = Player(self.objects, 180, 120)
    self.camera = Camera(self.player, { damping = 12 })

    Enemy(self.objects, 700, 120, 'bird', self.player)
    -- self.timer = Timer.new()
    -- self.timer:every(60, function()
    --     Raindrop(self.objects, 200, -100, math.random(4, 50))
    -- end)
end

function Game:update(dt)
    self.player:update(dt)
    self.objects:update(dt)
    self.camera:follow(self.player)
    self.camera:update(dt)
    self.timer:update(dt)
end

function Game:draw()
    local camPos = self.camera:getPosition()
    local camX = -((camPos.x / 4) % 480)
    for x = camX, love.graphics.getWidth(), 480 do
        love.graphics.draw(sprites.backgroundBlur, x, 0)
    end
    self.camera:draw(function()
        self.player:draw()
        self.objects:draw()
    end)
end

return Game
