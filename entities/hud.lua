HUD = class('HUD')

function HUD:initialize()
    self.widgets = {}
end

function HUD:addWidget(widget)
    table.insert(self.widgets, widget)
end

function HUD:update(dt)
    for i, widget in pairs(self.widgets) do
        widget:update(dt)
    end
end

function HUD:draw()
    love.graphics.setColor(25, 25, 25, 75)
    love.graphics.polygon("fill",
        0, love.window.getHeight(),
        0, love.window.getHeight()-25,
        love.window.getWidth()/2-200, love.window.getHeight()-75,
        love.window.getWidth()/2+200, love.window.getHeight()-75,
        love.window.getWidth(), love.window.getHeight()-25,
        love.window.getWidth(), love.window.getHeight()
    )

    love.graphics.setColor(22, 22, 22, 127)
    love.graphics.rectangle("fill", 0, love.graphics.getHeight()-25, love.graphics.getWidth(), 25)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font[16])
    love.graphics.print(the.player.location, love.graphics.getWidth()/2 - love.graphics.getFont():getWidth(the.player.location)/2, love.graphics.getHeight()-27)

    for i, widget in pairs(self.widgets) do
        widget:draw()
    end

    love.graphics.setColor(255, 255, 255)
    love.graphics.origin()
end