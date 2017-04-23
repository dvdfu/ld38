local Vector = require 'modules.hump.vector'
local Gamestate = require 'modules.hump.gamestate'
local Signal = require 'modules.hump.signal'
local Timer = require 'modules.hump.timer'
local Transition = require 'src.states.transition'
local Player = require 'src.objects.player'
local Raindrop = require 'src.objects.raindrop'
local Camera = require 'src.camera'
local ChunkSpawner = require 'src.chunkSpawner'
local Constants = require 'src.constants'
local Music = require 'src.music'
local Objects = require 'src.objects'
local Rain = require 'src.rain'

local Game = {}

local sprites = {
    background = love.graphics.newImage('res/background_blur.png'),
    foreground = love.graphics.newImage('res/foreground_blur.png'),
}

function Game:init()
    Signal.register('cam_shake', function(shake)
        self.camera:shake(shake)
    end)
    Music.game()
    self.transition = Transition()
end

function Game:enter()
    self.transition:fadeIn()
    self.objects = Objects()
    self.player = Player(self.objects, 0, 120)
    local x, y = self.player:getPosition():unpack()
    self.camera = Camera(x, Constants.GAME_HEIGHT / 2, 12)
    self.chunkSpawner = ChunkSpawner(self.objects, self.player)

    self.rain = Rain()
    self.timer = Timer.new()
    self.timer:every(1, function()
        self.rain:add(math.random() * Constants.GAME_WIDTH)
        self.rain:add(math.random() * Constants.GAME_WIDTH)
    end)
end

function Game:update(dt)
    self.transition:update(dt)
    local mousePos = self.camera:getPosition() + Vector(love.mouse.getPosition()) / 2 - Camera.HALF_SCREEN
    self.player:setMouse(mousePos)
    self.player:update(dt)
    self.objects:update(dt)

    local px, py = self.player:getPosition():unpack()
    self.camera:follow(px + 100)
    self.chunkSpawner:update(dt)
    self.camera:update(dt)
    self.rain:update(dt)
    self.timer:update(dt)
    Music.update(dt)

    -- for now
    Music.setFade(1 - self.player.bees / 100)

    -- if the player is under something, quieten the rain
    Music.setPrevQuietRain()
    if py > 0 then
        self.objects:getWorld():rayCast(px, py, px, 0, function (fixture, x, y, xn, yn, fraction)
            if fixture:getUserData():hasTag('bee') or
               fixture:getUserData():hasTag('raindrop') or
               fixture:getUserData():hasTag('enemy') then
                return -1
            end

            Music.tryPlayingQuietRain()
            return 0
        end)
    end
    Music.tryPlayingLoudRain()
end

function Game:keypressed(key)
    if Constants.DEBUG and key == 'r' then
        Gamestate.switch(Game)
    end
end

function Game:draw()
    local camPos = self.camera:getPosition()
    local camX = -((camPos.x / 4) % 480)
    for x = camX, love.graphics.getWidth(), 480 do
        love.graphics.draw(sprites.background, x, 0)
    end

    camX = -((camPos.x / 2) % 320)
    for x = camX, love.graphics.getWidth(), 320 do
        love.graphics.draw(sprites.foreground, x, Constants.GAME_HEIGHT - 160)
    end

    self.rain:draw()
    self.camera:draw(function()
        self.chunkSpawner:draw()
        self.objects:draw()
        self.player:draw()
    end)

    love.graphics.setFont(Constants.FONTS.REDALERT)
    local distance = math.floor(self.player:getDistance() / 12)
    local meters = math.floor(distance / 100)
    local centimeters = distance % 100
    if centimeters < 10 then
        centimeters = '0' .. centimeters
    end
    love.graphics.printf(meters .. '.' .. centimeters .. ' m',
        Constants.GAME_WIDTH / 2 - 20,
        Constants.GAME_HEIGHT - 80,
        40, 'right')

    self.transition:draw()
end

return Game
