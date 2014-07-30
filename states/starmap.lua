starmap = {}

function starmap:init()
    
end

function starmap:enter()
    self.translateX = love.window.getWidth()/2
    self.translateY = love.window.getHeight()/2

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
end

function starmap:keypressed(key, isrepeat)
    if key == "m" then
        state.switch(game)
    end
end

function starmap:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font[16])

    -- draw planets
    love.graphics.push()
    love.graphics.translate(self.translateX, self.translateY)

    for systemName, system in pairs(game.systems) do
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
end
