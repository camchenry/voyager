HullDisplay = class("HullDisplay")

function HullDisplay:initialize()
    self.ratio = 1
end

function HullDisplay:update(dt)
    self.ratio = the.player.ship.hull / the.player.ship.maxHull

    self.x = 5
    self.y = love.window.getHeight() - 20

    self.width = love.graphics.getWidth()/2 - 200
    self.height = 17
end

function HullDisplay:draw()
    love.graphics.setLineWidth(1)

    local stencil = function()
        love.graphics.polygon("fill",
            self.x, self.y, 
            self.x + self.width, self.y - 45, 
            self.x + self.width, self.y + self.height - 45,
            self.x, self.y+self.height)
    end

    love.graphics.setStencil(stencil)

    love.graphics.setColor(127, 127, 127, 33)
    love.graphics.rectangle("fill", self.x, self.y-100, self.width, self.height*10)
    love.graphics.setColor(255, 66, 33, 110)
    love.graphics.rectangle("fill", self.x, self.y-100, self.width*self.ratio, self.height*10)

    love.graphics.setStencil()
    love.graphics.setColor(255, 255, 255)

    love.graphics.setFont(font[16])
    local rotation = math.atan2(self.height+45, self.width) - 0.04
    local text = the.player.ship.hull .. ' / ' .. the.player.ship.maxHull .. ' (' .. tostring(math.floor(self.ratio*100))..'%)'
    local y = (self.y+self.y-45)/2 - 3
    love.graphics.print(text, self.x+self.width/2-love.graphics.getFont():getWidth(text)/2, y, -rotation)

    love.graphics.origin()
end