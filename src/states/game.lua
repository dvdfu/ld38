local Bump = require 'modules.bump.bump'
local Vector = require 'modules.hump.camera'
local Player = require 'src.objects.player'
local Ground = require 'src.objects.ground'
local Camera = require 'src.camera'

local Game = {}

local sprites = {
    backgroundBlur = love.graphics.newImage('res/background_blur.png'),
}

function Game:enter()
    self.world = Bump.newWorld()
    self.objects = {}
    local player = Player(self.world, 100, 100)
    table.insert(self.objects, player)
    table.insert(self.objects, Ground(self.world, 0, 200, 200, 32))
    table.insert(self.objects, Ground(self.world, 100, 300, 400, 32))
    table.insert(self.objects, Ground(self.world, 300, 200, 32, 200))

    self.camera = Camera(player, {
        damping = 12,
        buffer = Vector(32, 24)
    })
end

function Game:update(dt)
    for _, object in pairs(self.objects) do
        object:update(dt)
    end

    self.camera:update(dt)
end

function Game:draw()
    local camPos = self.camera:getPosition()
    local camX = -((camPos.x / 4) % 480)
    for x = camX, love.graphics.getWidth(), 480 do
        love.graphics.draw(sprites.backgroundBlur, x, 0)
    end

    self.camera:draw(function()
        for _, object in pairs(self.objects) do
            object:draw()
        end
    end)
end

return Game
