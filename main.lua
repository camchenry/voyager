-- libraries
class = require 'libs.middleclass'
vector = require 'libs.vector'
state = require 'libs.state'
tween = require 'libs.tween'
fx = require 'libs.fx'
require 'libs.generalmath'
require 'libs.util'

-- gamestates
require 'states.init'

-- entities
require 'entities.init'

function love.load()
	love.window.setTitle(config.windowTitle)
    love.window.setIcon(love.image.newImageData(config.windowIcon))
	love.graphics.setDefaultFilter(config.filterModeMin, config.filterModeMax, config.anisotropy)
    love.graphics.setFont(font[14])

    math.randomseed(os.time()/10)

    love.keyboard.setKeyRepeat(true)

	local loadedOptions = options:load()
	if not loadedOptions then
		--love.window.setMode(1024, 768, {fullscreen = true}) -- default
		love.window.setMode(1024, 768) -- default
	end

    the = {}
    the.player = nil
    the.system = nil

    state.registerEvents()
    state.switch(menu)
end

function love.update(dt)
    tween.update(dt)
end

function love.draw()
    fx.draw()
end
