local Bump = require 'modules.bump.bump'
local Player = require 'src.objects.player'
local Ground = require 'src.objects.ground'

local Game = {}

function Game:enter()
    self.world = Bump.newWorld()
    self.objects = {}
    table.insert(self.objects, Player(self.world, 100, 100))
    table.insert(self.objects, Ground(self.world, 0, 200, 200, 32))
    table.insert(self.objects, Ground(self.world, 100, 300, 400, 32))
    table.insert(self.objects, Ground(self.world, 300, 200, 32, 200))
end

function Game:update(dt)
    for _, object in pairs(self.objects) do
        object:update(dt)
    end
end

function Game:draw()
    for _, object in pairs(self.objects) do
        object:draw()
    end
end

return Game
