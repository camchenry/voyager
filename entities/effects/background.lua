StarBackground = class("StarBackground")

function StarBackground:initialize()
    self:recreate()    
end

function StarBackground:recreate()
    self.starQuad = love.graphics.newQuad(0, 0, love.window.getWidth()*2, love.window.getHeight()*2, 512, 512)
    self.nebulaQuad = love.graphics.newQuad(0, 0, love.window.getWidth(), love.window.getHeight(), love.window.getWidth(), love.window.getHeight())
    self.starImage = love.graphics.newImage('img/starField2.png')
    self.starImage:setWrap("repeat")
end

function StarBackground:update(dt)

end

function StarBackground:draw()
    local x, y = 0, 0
    
    for i = 1, 5 do
        if the.player.ship and not the.player.ship.destroyed then
            x, y = the.player.ship.body:getPosition()
            
            local divisor = 6*i

            if i == 1 then
                divisor = 3
            end

            if i == 5 then
                divisor = 60
            end

            x, y = math.floor(x/divisor), math.floor(y/divisor)
            local w, h = self.starImage:getDimensions()
            x = (x + 777*i) % w
            y = (y - 345*i) % h
        end

        love.graphics.draw(self.starImage, self.starQuad, -x, -y)
    end
end