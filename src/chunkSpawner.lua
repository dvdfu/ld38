local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Flower = require 'src.objects.flower'
local Fly = require 'src.objects.fly'
local Frog = require 'src.objects.frog'
local Raindrop = require 'src.objects.raindrop'
local Constants = require 'src.constants'

local Chunk = Class.new()

function Chunk:init(objects, id, player)
    self.x = id * Constants.GAME_WIDTH
    self.h = Constants.GAME_HEIGHT
    self.timer = Timer.new()
    self.objects = objects
    self.player = player

    if id == 0 then return end

    if true then
        self:spawnFrog()
    else
        self:spawnFlies(math.random(0, 2))
        self:spawnDrips(math.random(1, 8))
        self:spawnFlowers(math.random(1, 8))
    end
end

function Chunk:spawnFrog()
    Frog(self.objects, self.x + Constants.GAME_WIDTH / 2, Constants.GAME_HEIGHT, self.player)
end

function Chunk:spawnFlies(n)
    for i = 1, n do
        local x = self.x + math.random() * Constants.GAME_WIDTH
        local y = math.random() * Constants.GAME_HEIGHT
        Fly(self.objects, x, y, self.player)
    end
end

function Chunk:spawnFlowers(n)
    for i = 1, n do
        local x = (i - math.random()) * Constants.GAME_WIDTH / n
        local h = math.random(40, 200)
        Flower(self.objects, self.x + x, self.h - h)
    end
end

function Chunk:spawnDrips(n)
    for i = 1, n do
        local size = math.random(4, 24)
        local cooldown = 20 + 3 * size
        local x = math.random() * Constants.GAME_WIDTH
        self.timer:every(cooldown, function()
            Raindrop(self.objects, self.x + x, -50, size)
        end)
    end
end

function Chunk:update(dt)
    self.timer:update(dt)
end

function Chunk:draw()
    if Constants.DEBUG then
        love.graphics.push('all')
            if (self.x / Constants.GAME_WIDTH) % 2 == 0 then
                love.graphics.setColor(52, 152, 219, 50)
            else
                love.graphics.setColor(231, 76, 60, 50)
            end

            love.graphics.rectangle('fill', self.x, 0, Constants.GAME_WIDTH, self.h)
        love.graphics.pop()
    end
end

--------------------------------------------------------------------------------

local ChunkSpawner = Class.new()
ChunkSpawner.NUM_CHUNKS = 2

function ChunkSpawner:init(objects, player)
    self.objects = objects
    self.player = player
    self.chunkCount = 0
    self.chunks = {}

    self:generateChunks()
end

function ChunkSpawner:generateChunks()
    for i = 1, ChunkSpawner.NUM_CHUNKS do
        table.insert(self.chunks, Chunk(self.objects, self.chunkCount, self.player))
        self.chunkCount = self.chunkCount + 1
    end
end

function ChunkSpawner:update(dt)
    if self.player:getPosition().x > (self.chunkCount - 1) * Constants.GAME_WIDTH then
        self:generateChunks()
    end

    for _, chunk in pairs(self.chunks) do
        chunk:update(dt)
    end
end

function ChunkSpawner:draw()
    for _, chunk in pairs(self.chunks) do
        chunk:draw()
    end
end

return ChunkSpawner
