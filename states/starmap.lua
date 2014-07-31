starmap = {}

function starmap:init()
    self.rawSystemData = require 'data.systems'
end

function starmap:enter()
    self.translateX = love.window.getWidth()/2
    self.translateY = love.window.getHeight()/2

    self.mouseX = 0
    self.mouseY = 0

    self.selectedSystem = nil

    love.mouse.setVisible(false)
end

function starmap:leave()
    love.mouse.setVisible(true)
end

function starmap:update(dt)
    local centerX, centerY = love.window.getWidth()/2, love.window.getHeight()/2
    love.mouse.setPosition(centerX, centerY)

    local dx, dy = centerX - love.mouse.getX(), centerY - love.mouse.getY()
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
        local mouseX, mouseY = love.window.getWidth()/2, love.window.getHeight()/2

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
    end

    love.graphics.pop()

    -- middle indicator
    local centerX, centerY = love.window.getWidth()/2, love.window.getHeight()/2
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