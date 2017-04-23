local Class = require 'modules.hump.class'
local Chunk = require 'src.chunk'

local ChunkSpawner = Class.new()
ChunkSpawner.NUM_CHUNKS = 2

function ChunkSpawner:init(objects, player)
    self.objects = objects
    self.player = player
    self.chunkWidth = love.graphics.getWidth()
    self.chunkCount = 0
    self.chunks = {}

    ChunkSpawner:generateChunks(self)
end

function ChunkSpawner:generateChunks(self)
    for i = 1, ChunkSpawner.NUM_CHUNKS do
        table.insert(self.chunks, Chunk(self.objects, self.player, self.chunkCount, self.chunkCount * self.chunkWidth, self.chunkWidth))
        self.chunkCount = self.chunkCount + 1
    end
end

function ChunkSpawner:update(dt)
    if self.player:getPosition().x > (self.chunkCount - 1) * self.chunkWidth then
        ChunkSpawner:generateChunks(self)
    end

    for _, chunk in pairs(self.chunks) do
        chunk:update(dt)
    end
end

return ChunkSpawner
