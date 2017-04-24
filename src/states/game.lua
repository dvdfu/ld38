local Vector = require 'modules.hump.vector'
local Signal = require 'modules.hump.signal'
local Gamestate = require 'modules.hump.gamestate'
local Timer = require 'modules.hump.timer'

local Constants = require 'src.constants'
local Camera = require 'src.camera'
local Music = require 'src.music'

local Finale = require 'src.states.finale'
local Transition = require 'src.states.transition'

local ChunkSpawner = require 'src.chunkSpawner'
local Rain = require 'src.rain'
local Objects = require 'src.objects'

local Player = require 'src.objects.player'
local Flower = require 'src.objects.flower'

local Game = {}
Game.DISTANCE = Constants.GAME_WIDTH * (Constants.DEBUG and 2 or 20)

local sprites = {
    background = love.graphics.newImage('res/background_blur.png'),
    foreground = love.graphics.newImage('res/foreground_blur.png'),
    splash = love.graphics.newImage('res/raindrop_particle.png'),
    hudTree = love.graphics.newImage('res/hud_tree.png'),
    hudBee = love.graphics.newImage('res/hud_bee.png'),
}

function Game:init()
    Signal.register('cam_shake', function(shake)
        self.camera:shake(shake)
    end)
    Signal.register('splash', function(x, y, size)
        self.splashParticles:setPosition(x, y + size / 2)
        self.splashParticles:emit(math.floor(size / 4))
    end)

    Music.game()
    self.transition = Transition()
end

function Game:enter()
    self.transitioning = false
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
    self.beeCount = self.player:numBees()

    self.splashParticles = love.graphics.newParticleSystem(sprites.splash)
    self.splashParticles:setOffset(8, 8)
    self.splashParticles:setSizes(2, 0)
    self.splashParticles:setParticleLifetime(20)
    self.splashParticles:setDirection(-math.pi / 2)
    self.splashParticles:setSpread(math.pi / 2)
    self.splashParticles:setSpeed(2, 4)
    self.splashParticles:setLinearAcceleration(0, 0.2)
end

function Game:update(dt)
    self.transition:update(dt)
    local mousePos = self.camera:getPosition() + Vector(love.mouse.getPosition()) / 2 - Camera.HALF_SCREEN
    self.player:setMouse(mousePos)
    self.player:update(dt)

    -- Remove objects that are off the screen
    for _, object in pairs(self.objects.objects) do
        if object:getPosition().x < self.player:getPosition().x - Constants.GAME_WIDTH or
           object:getPosition().y > Constants.GAME_HEIGHT * 1.5 then
            if object:hasTag('bee') then
                object.dead = true
            end

            if not object:isDead() then
                object.body:destroy()
            end
        end
    end

    for _, object in pairs(self.objects.objects) do
        if object:hasTag('flower') and
           not object.pollinated and
           object:getPosition():dist(self.player:getPosition()) < Flower.POLLINATION_RADIUS then
               object.pollinated = true

               local x, y = object:getPosition():unpack()
               for i = 1, object.numBees do
                   self.player:spawnBee(self.objects, x, y, self.player)
               end
        end
    end

    self.objects:update(dt)

    local px, py = self.player:getPosition():unpack()
    self.camera:follow(px + 100)
    self.chunkSpawner:update(dt)
    self.camera:update(dt)
    self.rain:update(dt)
    self.timer:update(dt)
    self.splashParticles:update(dt)
    Music.update(dt)

    -- for now
    self.beeCount = self.player:numBees()
    Music.setFade(1 - self.beeCount / 100)

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

    if self.player:getDistance() >= Game.DISTANCE then
        if not self.transitioning then
            self.transitioning = true
            self.transition:fadeOut(function()
                Gamestate.switch(Finale)
            end)
        end
    end
end

function Game:keypressed(key)
    if Constants.DEBUG and key == 'r' then
        Gamestate.switch(Game)
    elseif key == 'e' then
        Constants.DEBUG = not Constants.DEBUG
    elseif key == 'space' then
        self.player:shoot()
    end
end

function Game:draw()
    -- draw backgrounds
    local camPos = self.camera:getPosition()
    local camX = -((camPos.x / 4) % 480)
    for x = camX, love.graphics.getWidth(), 480 do
        love.graphics.draw(sprites.background, x, 0)
    end

    camX = -((camPos.x / 2) % 320)
    for x = camX, love.graphics.getWidth(), 320 do
        love.graphics.draw(sprites.foreground, x, Constants.GAME_HEIGHT - 160)
    end

    -- draw objects
    self.rain:draw()
    self.camera:draw(function()
        self.chunkSpawner:draw()
        self.objects:draw()
        love.graphics.draw(self.splashParticles)
        self.player:draw()
    end)

    self:drawHUD()

    self.transition:draw()
end

function Game:drawHUD()
    local progress = self.player:getDistance() / Game.DISTANCE

    love.graphics.setColor(255, 255, 255, 128)
    love.graphics.rectangle('fill', Constants.GAME_WIDTH / 2 - 120, 24 - 2, 240, 4)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle('fill', Constants.GAME_WIDTH / 2 - 120, 24 - 2, 240 * progress, 4)

    love.graphics.draw(sprites.hudTree, Constants.GAME_WIDTH / 2 + 120, 24, 0, 1, 1, 8, 8)
    love.graphics.draw(sprites.hudBee, Constants.GAME_WIDTH / 2 - 120 + 240 * progress, 24 - 1, 0, 1, 1, 8, 8)

    love.graphics.setFont(Constants.FONTS.REDALERT)
    love.graphics.printf(self.beeCount, Constants.GAME_WIDTH / 2 - 120 + 240 * progress - 20, 29, 40, 'center')
end

return Game
