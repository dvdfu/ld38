local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Flower = require 'src.objects.flower'
local Fly = require 'src.objects.fly'
local Raindrop = require 'src.objects.raindrop'
local Constants = require 'src.constants'

local Chunk = Class.new()
Chunk.FLOWERS = 4 -- 1 to 3 flowers per chunk

function Chunk:init(objects, id, player)
    self.x = id * Constants.GAME_WIDTH
    self.h = Constants.GAME_HEIGHT
    self.timer = Timer.new()

    if id > 0 then
        local numFlowers = math.random(1, Chunk.FLOWERS)
        for i = 1, numFlowers do
            local fx = (i - math.random()) * Constants.GAME_WIDTH / numFlowers
            table.insert(objects, Flower(objects, self.x + fx, self.h - math.random(40, 200)))
        end

        local dropletSize = math.random(4, 30)
        local cooldown = 40 + 2 * dropletSize
        self.raindropSpawner = Constants.GAME_WIDTH * math.random() -- x position
        self.timer:every(cooldown, function()
            Raindrop(objects, self.x + self.raindropSpawner, -50, dropletSize)
        end)

        Fly(objects, self.x, 100, player)
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
