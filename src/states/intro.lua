local Gamestate = require 'modules.hump.gamestate'
local Vector = require 'modules.hump.vector'
local Transition = require 'src.states.transition'
local Player = require 'src.objects.player'
local Constants = require 'src.constants'
local Music = require 'src.music'
local Objects = require 'src.objects'
local Rain = require 'src.rain'
local Timer = require 'modules.hump.timer'
local Flower = require 'src.objects.flower'

local sprites = {
    logo = love.graphics.newImage('res/title_logo.png'),
}

local Intro = {}

function Intro:init()
    self.transition = Transition()
end

function Intro:enter()
    Music.init()
    self.objects = Objects()
    self.player = Player(self.objects, Constants.GAME_WIDTH / 2 + 80, Constants.GAME_HEIGHT * 3 / 4, true)
    self.rain = Rain()
    self.timer = Timer.new()
    self.timer:every(1, function()
        self.rain:add(math.random() * Constants.GAME_WIDTH)
        self.rain:add(math.random() * Constants.GAME_WIDTH)
    end)

    self.flower = Flower(self.objects, Constants.GAME_WIDTH - 150, Constants.GAME_HEIGHT - 50)

    self.state = { countdown = 3, textOpacity = 0 }
    self.starting = false
    self.startTimer = Timer.new()

    self.transitioning = false
    self.transition:fadeIn()
end

function Intro:update(dt)
    local mousePos = Vector(love.mouse.getPosition()) / 2
    self.player:setMouse(mousePos)
    self.objects:update(dt)
    self.player:update(dt)
    self.rain:update(dt)
    self.transition:update(dt)
    self.timer:update(dt)
    self.startTimer:update(dt)

    local dist = self.player:getPosition():dist(self.flower:getPosition())
    local flowerDist = 50
    local slope = 1.0 * (255) / (-flowerDist)
    self.state.textOpacity = slope * (dist - flowerDist)
    if self.state.textOpacity < 0 then self.state.textOpacity = 0 end
    if self.state.textOpacity > 200 then self.state.textOpacity = 255 end

    if dist < flowerDist and not self.starting then
        self.starting = true
        self.startTimer:after(60, function()
            self.state.countdown = 2
            self.startTimer:after(60, function()
                self.state.countdown = 1
                self.startTimer:after(60, function()
                    self.state.countdown = "Go!"
                    self.transitioning = true
                    self.transition:fadeOut(function()
                        local Game = require 'src.states.game'
                        Gamestate.switch(Game)
                    end)
                end)
            end)
        end)
    elseif self.starting and dist >= flowerDist then
        self.startTimer:clear()
        self.state.countdown = 3
        self.starting = false
    end
end

function Intro:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif not self.transitioning and key == 'return' then
        self.transitioning = true
        self.transition:fadeOut(function()
            local Game = require 'src.states.game'
            Gamestate.switch(Game)
        end)
    end
end

function Intro:draw()
    love.graphics.draw(sprites.logo, Constants.GAME_WIDTH / 2, 120, 0, 1, 1, 200, 80)

    love.graphics.setFont(Constants.FONTS.REDALERT)
    love.graphics.print("Click & hold or WASD to move", 100, 220)
    love.graphics.print("Visit flowers to recruit bees", 100, 220 + 16)
    love.graphics.print("Get home safe! Fly to the flower to start!", 100, 220 + 32)
    love.graphics.setColor(128, 128, 128)
    love.graphics.print("@dvdfu, Hamdan Javeed, Seikun Kambashi", 100, 220 + 48)
    love.graphics.print("Ludum Dare 38: Small World", 100, 220 + 64)

    love.graphics.push('all')
        love.graphics.setColor(255, 255, 255, self.state.textOpacity)
        love.graphics.setFont(Constants.FONTS.REDALERT_LARGE)
        love.graphics.printf(self.state.countdown, 375, 190, 150, 'center')
    love.graphics.pop()
    love.graphics.setColor(255, 255, 255)

    self.objects:draw()
    self.player:draw()
    self.rain:draw()

    self.transition:draw()
end

return Intro
