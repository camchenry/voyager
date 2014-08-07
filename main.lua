-- libraries
class = require 'libs.middleclass'
vector = require 'libs.vector'
state = require 'libs.state'
tween = require 'libs.tween'
fx = require 'libs.fx'
require 'libs.util'

-- gamestates
require 'states.menu'
require 'states.game'
require 'states.start'
require 'states.continue'
require 'states.options'
require 'states.starmap'
require 'states.landed'
require 'states.tradecenter'

-- entities
require 'entities.ui.button'
require 'entities.ui.checkbox'
require 'entities.ui.input'
require 'entities.ui.list'

require 'entities.control.player'
require 'entities.control.computer'

require 'entities.hud.radar'

require 'entities.hud'
require 'entities.pilot'
require 'entities.system'
require 'entities.ship'
require 'entities.planet'

function love.load()
	love.window.setTitle(config.windowTitle)
    love.window.setIcon(love.image.newImageData(config.windowIcon))
	love.graphics.setDefaultFilter(config.filterModeMin, config.filterModeMax, config.anisotropy)
    love.graphics.setFont(font[14])

    math.randomseed(os.time()/10)

    love.keyboard.setKeyRepeat(true)

	local loadedOptions = options:load()
	if not loadedOptions then
		love.window.setMode(1024, 768, {fullscreen = true}) -- default
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