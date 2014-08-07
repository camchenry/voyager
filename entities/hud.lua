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
    love.graphics.setColor(33, 33, 33, 127)
    love.graphics.polygon("fill",
        0, love.window.getHeight(),
        0, love.window.getHeight()-25,
        love.window.getWidth()/2-200, love.window.getHeight()-75,
        love.window.getWidth()/2+200, love.window.getHeight()-75,
        love.window.getWidth(), love.window.getHeight()-25,
        love.window.getWidth(), love.window.getHeight()
    )

    for i, widget in pairs(self.widgets) do
        widget:draw()
    end

    love.graphics.setColor(255, 255, 255)
end