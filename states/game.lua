game = {}

function game:enter()
    
end

function game:update(dt)

end

function game:keypressed(key, isrepeat)

end

function game:draw()
    local text = "This is the game"
    local x = love.window.getWidth()/2 - fontBold[48]:getWidth(text)/2
    local y = love.window.getHeight()/2
    love.graphics.setFont(fontBold[48])
    love.graphics.print(text, x, y)
end