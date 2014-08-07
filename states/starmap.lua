starmap = {}

function starmap:init()
    self.rawSystemData = require 'data.systems'

    self.translateX = love.window.getWidth()/2
    self.translateY = love.window.getHeight()/2

    self.mouseX = 0
    self.mouseY = 0
end

function starmap:enter()
    self.translateX = love.window.getWidth()/2 - the.system.x
    self.translateY = love.window.getHeight()/2 - the.system.y
	
	self.centerX, self.centerY = love.window.getWidth()/2, love.window.getHeight()/2

    self.mouseX = 0
    self.mouseY = 0

    self.selectedSystem = nil

    love.mouse.setVisible(false)
	
	self.first = true
end

function starmap:leave()
    love.mouse.setVisible(true)
end

function starmap:focus(f)
	if f then self.first = true end
end

function starmap:update(dt)
    local centerX, centerY = self.centerX, self.centerY
    if love.window.hasMouseFocus() then -- Prevents the mouse being grabbed by the game while alt-tabbing
		love.mouse.setPosition(centerX, centerY)
	end

	local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
	if self.first then -- The first time through, the mouse will always be at the center of the screen
		self.first = false
		mouseX, mouseY = centerX, centerY
	end
	
    local dx, dy = centerX - mouseX, centerY - mouseY
    self.translateX = self.translateX + dx
    self.translateY = self.translateY + dy

    self.mouseX = self.translateX - centerX
    self.mouseY = self.translateY - centerY
end

function starmap:keypressed(key, isrepeat)
    if key == "m" then
        state.switch(game)
    end
end

function starmap:mousepressed(x, y, button)
    if button == "l" then
        local mouseX, mouseY = self.centerX, self.centerY

        for systemName, system in pairs(self.rawSystemData) do
            local dist = math.sqrt((system.x + self.translateX - mouseX)^2 + (system.y + self.translateY - mouseY)^2)

            if dist < 20 and systemName ~= the.player.location then
                self.selectedSystem = systemName
                break
            else
                self.selectedSystem = nil
            end
        end
    end
end

function starmap:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font[16])

    -- draw systems
    love.graphics.push()
    love.graphics.translate(self.translateX, self.translateY)

    for systemName, system in pairs(self.rawSystemData) do
        love.graphics.circle("line", system.x, system.y, 10)
        love.graphics.print(systemName, system.x+12, system.y-25)

        -- current location indicator
        if systemName == the.system.name then
            love.graphics.setColor(0, 255, 255)
            love.graphics.circle("fill", system.x, system.y, 5)
            love.graphics.setColor(255, 255, 255)
        -- selected system jump line
        elseif systemName == self.selectedSystem then
            love.graphics.setColor(255, 255, 255, 33)
            love.graphics.line(system.x, system.y, the.system.x, the.system.y)
            love.graphics.setColor(255, 255, 255, 255)
        end
    end

    love.graphics.pop()

    -- middle indicator
    local centerX, centerY = self.centerX, self.centerY
    love.graphics.circle("fill", centerX, centerY, 3)

    -- x and y text
    love.graphics.setFont(font[24])
    love.graphics.print(self.translateX-centerX..', '..self.translateY-centerY)

    -- selected system
    if self.selectedSystem ~= nil then
        love.graphics.setFont(font[36])
        love.graphics.print(self.selectedSystem, 0, 75)
    end
end
