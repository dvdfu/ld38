local Class = require 'modules.hump.class'
local Timer = require 'modules.hump.timer'
local Flower = require 'src.objects.flower'
local Fly = require 'src.objects.fly'
local Frog = require 'src.objects.frog'
local Raindrop = require 'src.objects.raindrop'
local Constants = require 'src.constants'
local Tree = require 'src.objects.tree'

local Chunk = Class.new()

function Chunk:init(objects, id, player)
    self.x = (id - 1) * Constants.GAME_WIDTH
    self.h = Constants.GAME_HEIGHT
    self.timer = Timer.new()
    self.objects = objects
    self.player = player

    if id == Constants.TOTAL_CHUNKS then
        self:spawnTree()
    elseif id == 1 then
        self:spawnFlowers(math.random(1, 3))
        return
    elseif math.random(1, 4) == 1 then
        self:spawnFrog()
        self:spawnDrips(math.random(1, 2))
    else
        if math.random(1, 4) == 1 then
            self:spawnFrog()
            self:spawnDrips(math.random(1, 2))
        else
            self:spawnFlies(math.random(0, 1))
            self:spawnDrips(math.random(1, 4))
            self:spawnFlowers(math.random(1, 5))
        end
    end
end

function Chunk:spawnTree()
    Tree(self.objects, self.x + Constants.GAME_WIDTH)
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
        local cooldown = 32 + 2 * size
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
ChunkSpawner.NUM_CHUNKS = 1

function ChunkSpawner:init(objects, player)
    self.objects = objects
    self.player = player
    self.chunkId = 1
    self.chunks = {}

    self:generateChunks()
end

function ChunkSpawner:generateChunks()
    for i = 1, ChunkSpawner.NUM_CHUNKS do
        table.insert(self.chunks, Chunk(self.objects, self.chunkId, self.player))
        self.chunkId = self.chunkId + 1
    end
end

function ChunkSpawner:update(dt)
    if self.player:getPosition().x > (self.chunkId - 2) * Constants.GAME_WIDTH and self.chunkId <= Constants.TOTAL_CHUNKS then
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
