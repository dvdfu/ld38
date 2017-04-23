local Class = require 'modules.hump.class'
local Chunk = require 'src.chunk'
local Constants = require 'src.constants'

local ChunkSpawner = Class.new()
ChunkSpawner.NUM_CHUNKS = 2

function ChunkSpawner:init(objects, player)
    self.objects = objects
    self.player = player
    self.chunkCount = 0
    self.chunks = {}

    ChunkSpawner:generateChunks(self)
end

function ChunkSpawner:generateChunks(self)
    for i = 1, ChunkSpawner.NUM_CHUNKS do
        table.insert(self.chunks, Chunk(self.objects, self.chunkCount, Constants.GAME_WIDTH))
        self.chunkCount = self.chunkCount + 1
    end
end

function ChunkSpawner:update(dt)
    if self.player:getPosition().x > (self.chunkCount - 1) * Constants.GAME_WIDTH then
        ChunkSpawner:generateChunks(self)
    end

    for _, chunk in pairs(self.chunks) do
        chunk:update(dt)
    end
end

return ChunkSpawner
