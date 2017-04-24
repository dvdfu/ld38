local Class = require 'modules.hump.class'

local Animation = Class.new()

function Animation:init(source, frames, frameLength, playOnce)
    self.source = source
    self.quads = {}

    local sw, sh = source:getDimensions()
    local fw = math.floor(sw / frames)
    for i = 1, frames do
        local x = (i - 1) * fw
        self.quads[i] = love.graphics.newQuad(x, 0, fw, sh, sw, sh)
    end

    self.frames = frames
    self.frameLength = frameLength
    self.playOnce = playOnce
    self.playing = false
    self.tick = 0
    self.frame = 1
end

function Animation:update(dt)
    if not self.playOnce or self.playing then
        self.tick = self.tick + dt
    end
    while self.tick > self.frameLength do
        self.tick = self.tick - self.frameLength
        self.frame = self.frame + 1
        if self.frame > self.frames then
            self.playing = false
            self.frame = self.frame - self.frames
        end
    end
    while self.tick < 0 do
        self.tick = self.tick + self.frameLength
        self.frame = self.frame - 1
        if self.frame < 1 then
            self.frame = self.frame + self.frames
        end
    end
end

function Animation:play()
    self.playing = true
    self.tick = 0
    self.frame = 1
end

function Animation:draw(...)
    if self.playOnce and not self.playing then return end
    local quad = self.quads[self.frame]
    love.graphics.draw(self.source, quad, ...)
end

return Animation
