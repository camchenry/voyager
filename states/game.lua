game = {}

function game:init()
    self.system = StarSystem:new("Sol")
    the.system = self.system

    self.system:addEntity(Ship:new(self.system.world))
end

function game:enter()
    
end

function game:update(dt)
    self.system:update(dt)
end

function game:keypressed(key, isrepeat)

end

function game:draw()
    love.graphics.setColor(255, 255, 255)

    self.system:draw()
end