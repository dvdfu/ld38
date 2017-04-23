local Music = {}

local loud = love.audio.newSource('res/sounds/bee_dangerous.mp3')
local soft = love.audio.newSource('res/sounds/bee_calm.mp3')
local rain = love.audio.newSource('res/sounds/rain.wav')

function Music.init()
    soft:setLooping(true)
    rain:setLooping(true)
    rain:setVolume(0.4)

    soft:play()
    rain:play()
end

return Music
