local Music = {}

local loud = love.audio.newSource('res/sounds/bee_dangerous.mp3')
local soft = love.audio.newSource('res/sounds/bee_calm.mp3')
local rain = love.audio.newSource('res/sounds/rain.wav')

function Music.intro()
    soft:setLooping(true)
    soft:play()
end

function Music.game()
    rain:setLooping(true)
    rain:setVolume(0.4)
    rain:play()
end

return Music
