local Music = {}

local loud = love.audio.newSource('res/sounds/bee_dangerous.mp3')
local soft = love.audio.newSource('res/sounds/bee_calm.mp3')
local rain = love.audio.newSource('res/sounds/rain.wav')

function Music.init()
    soft:setLooping(true)
    loud:setLooping(true)
    Music.setFade(0)

    soft:play()
    loud:play()
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
