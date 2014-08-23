Navigation = class("Navigation")

function Navigation:initialize()
    self.x = 0
    self.y = 0

    self.title = "NAVIGATION"
    self.subtitle = ""
end

function Navigation:setText(title, subtitle)
    subtitle = subtitle or ""

    self:setTitle(title)
    self:setSubtitle(subtitle)
end

function Navigation:setTitle(title)
    self.title = title
end

function Navigation:setSubtitle(subtitle)
    self.subtitle = subtitle
end

function Navigation:update(dt)

end

function Navigation:draw()
    love.graphics.setLineWidth(1)
    love.graphics.setColor(255, 255, 255)

    if love.window.getWidth() <= 1280 then
        love.graphics.translate(0, -35)
    end

    love.graphics.setFont(font[28])
    love.graphics.print(self.title, love.window.getWidth()/2 - love.graphics.getFont():getWidth(self.title)/2, 50)
    love.graphics.line(100, 150, 150, 100, love.window.getWidth()-150, 100, love.window.getWidth()-100, 150)

    love.graphics.setFont(fontLight[24])
    love.graphics.print(self.subtitle, love.window.getWidth()/2 - love.graphics.getFont():getWidth(self.subtitle)/2, 100)

    love.graphics.origin()
end