local Timer = require 'modules.hump.timer'

local Music = {}

Music.SOUNDTRACK_MAX_VOLUME = 0.8
Music.MODIFIER_DURATION = 40
Music.LOUD_RAIN_VOLUME = 0.75
Music.LOUD_RAIN_PITCH = 1.0
Music.QUIET_RAIN_VOLUME = 0.4
Music.QUIET_RAIN_PITCH = 0.6
Music.AUDIO_MAX_VOLUME = 10

local loud = love.audio.newSource('res/sounds/bee_dangerous.mp3', "stream")
local soft = love.audio.newSource('res/sounds/bee_calm.mp3', "stream")
local ambient = love.audio.newSource('res/sounds/bee_ambient.mp3', "stream")
local rain = love.audio.newSource('res/sounds/rain.mp3', "stream")

local prevQuietRain = false
local quietRain = false

local musicModifiers = { rainVolume = Music.LOUD_RAIN_VOLUME, rainPitch = Music.LOUD_RAIN_PITCH }
local modifiersChanging = false
local modifierTimer = Timer.new()

local music_volume = 6

function Music.init()
    soft:setLooping(true)
    loud:setLooping(true)
    ambient:setLooping(true)
    rain:setLooping(true)
    Music.setFade(0)

    soft:play()
    loud:play()
    ambient:play()
    rain:setVolume(musicModifiers.rainVolume)
    rain:play()
    love.audio.setVolume(music_volume / 10)
end

function Music.setFade(x)
    if x < 0 then x = 0 end
    if x > Music.SOUNDTRACK_MAX_VOLUME then x = Music.SOUNDTRACK_MAX_VOLUME end
    loud:setVolume(x)
    ambient:setVolume(x)
end

-- call before the raycast
function Music.setPrevQuietRain()
    prevQuietRain = quietRain
    quietRain = false
end

function Music.tryPlayingLoudRain()
    if prevQuietRain and not quietRain then
        local newModifiers = {
            rainVolume = Music.LOUD_RAIN_VOLUME,
            rainPitch = Music.LOUD_RAIN_PITCH
        }

        modifierTimer:clear()
        modifierTimer:tween(Music.MODIFIER_DURATION, musicModifiers, newModifiers, 'in-out-quad', function()
            modifiersChanging = false
        end)
        modifiersChanging = true
    end
end

function Music.tryPlayingQuietRain()
    if not prevQuietRain then
        local newModifiers = {
            rainVolume = Music.QUIET_RAIN_VOLUME,
            rainPitch = Music.QUIET_RAIN_PITCH
        }

        modifierTimer:clear()
        modifierTimer:tween(Music.MODIFIER_DURATION, musicModifiers, newModifiers, 'linear', function()
            modifiersChanging = false
        end)
        modifiersChanging = true
    end

    quietRain = true
end

function Music.volume_up()
    if music_volume < Music.AUDIO_MAX_VOLUME then
        music_volume = music_volume + 1
        love.audio.setVolume(music_volume / 10)
    end
end

function Music.volume_down()
    if music_volume > 0 then
        music_volume = music_volume - 1
        love.audio.setVolume(music_volume / 10)
    end
end

function Music.update(dt)
    modifierTimer:update(dt)

    if modifiersChanging then
        rain:setVolume(musicModifiers.rainVolume)
        rain:setPitch(musicModifiers.rainPitch)
    end
end

function Music.finale()
    Music.setFade(0)
    rain:stop()
    ambient:stop()
    love.audio.setVolume(music_volume / 10)
end

return Music
