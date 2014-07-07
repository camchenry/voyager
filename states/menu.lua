menu = {}

function menu:enter()
    
end

function menu:update(dt)

end

function menu:keyreleased(key, code)
    if key == 'return' then
        state.switch(game)
    end
end

function menu:draw()
    local text = "> ENTER <"
    local x = love.window.getWidth()/2 - fontBold[48]:getWidth(text)/2
    local y = love.window.getHeight()/2
    love.graphics.setFont(fontBold[48])
    love.graphics.print(text, x, y)
end