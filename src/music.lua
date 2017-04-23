local Timer = require 'modules.hump.timer'

local Music = {}

Music.SOUNDTRACK_MAX_VOLUME = 0.8

Music.LOUD_RAIN_VOLUME = 0.75
Music.LOUD_RAIN_PITCH = 1.0
Music.QUIET_RAIN_VOLUME = 0.4
Music.QUIET_RAIN_PITCH = 0.6

local loud = love.audio.newSource('res/sounds/bee_dangerous.wav')
local soft = love.audio.newSource('res/sounds/bee_calm.wav')
local ambient = love.audio.newSource('res/sounds/bee_ambient.wav')
local rain = love.audio.newSource('res/sounds/rain.wav')

local prevQuietRain = false
local quietRain = false

local musicModifiers = { rainVolume = Music.LOUD_RAIN_VOLUME, rainPitch = Music.LOUD_RAIN_PITCH }
local modifiersChanging = false
local modifierTimer = Timer.new()

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
    rain:setVolume(musicModifiers.rainVolume)
    rain:play()
end

function Music.setFade(x)
    if x < 0 then x = 0 end
    if x > Music.SOUNDTRACK_MAX_VOLUME then x = Music.SOUNDTRACK_MAX_VOLUME end
    soft:setVolume(Music.SOUNDTRACK_MAX_VOLUME - x)
    loud:setVolume(x)
end

-- call before the raycast
function Music.setPrevQuietRain()
    prevQuietRain = quietRain
    quietRain = false
end

function Music.maybePlayLoudRain()
    if prevQuietRain and not quietRain then
        local newModifiers = {
            rainVolume = Music.LOUD_RAIN_VOLUME,
            rainPitch = Music.LOUD_RAIN_PITCH
        }

        modifierTimer:clear()
        modifierTimer:tween(40, musicModifiers, newModifiers, 'in-out-quad', function()
            modifiersChanging = false
        end)
        modifiersChanging = true
    end
end

function Music.maybePlayQuietRain()
    if not prevQuietRain then
        local newModifiers = {
            rainVolume = Music.QUIET_RAIN_VOLUME,
            rainPitch = Music.QUIET_RAIN_PITCH
        }

        modifierTimer:clear()
        modifierTimer:tween(40, musicModifiers, newModifiers, 'linear', function()
            modifiersChanging = false
        end)
        modifiersChanging = true
    end

    quietRain = true
end

function Music.update(dt)
    modifierTimer:update(dt)

    if modifiersChanging then
        rain:setVolume(musicModifiers.rainVolume)
        rain:setPitch(musicModifiers.rainPitch)
    end
end

return Music
