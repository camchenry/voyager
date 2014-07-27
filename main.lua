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

-- entities
require 'entities.ui.button'
require 'entities.ui.input'
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

    --love.window.setMode(1024, 768, {fullscreen = false})

    the = {}
    the.player = nil
    the.system = nil

    game:loadSystems()

    state.registerEvents()
    state.switch(menu)
end

function love.update(dt)
    tween.update(dt)
end

function love.draw()
    fx.draw()
end