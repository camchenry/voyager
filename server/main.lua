-- libraries
class = require 'libs.middleclass'
vector = require 'libs.vector'
state = require 'libs.state'
flux = require 'libs.flux'

-- global libraries (the names within shouldn't change)
require 'libs.generalmath'
require 'libs.tablestring'
require 'libs.util'
require 'enet'

-- entities
--[[
require 'entities.ui.button'
require 'entities.ui.input'
require 'entities.pilot'
require 'entities.system'
require 'entities.ship'
]]

-- gamestates
require 'states.menu'
require 'states.game'

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

    state.registerEvents()
    state.switch(menu)
end

function love.update(dt)
    flux.update(dt)
end

function love.draw()
    --fx.draw()
end