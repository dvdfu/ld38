local Music = {}

local loud = love.audio.newSource('res/sounds/bee_dangerous.wav')
local soft = love.audio.newSource('res/sounds/bee_calm.wav')
local ambient = love.audio.newSource('res/sounds/bee_ambient.wav')
local rain = love.audio.newSource('res/sounds/rain.wav')

function Music.init()
    soft:setLooping(true)
    loud:setLooping(true)
    ambient:setLooping(true)
    ambient:setVolume(0.2)
    Music.setFade(0)

    soft:play()
    loud:play()
    ambient:play()
end

function Music.game()
    rain:setLooping(true)
    rain:setVolume(0.4)
    rain:play()
end

function Music.setFade(x)
    if x < 0 then x = 0 end
    if x > 1 then x = 1 end
    soft:setVolume(1 - x)
    loud:setVolume(x)
end

return Music
