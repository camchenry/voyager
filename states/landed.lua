landed = {}

landed.items = {
    {
        title = "TRADE CENTER",
        action = function()
            state.switch(tradecenter)
        end,
    },
	{
        title = "BBS",
        action = function()
            state.switch(bbs)
        end,
    },
    {
        title = "LEAVE",
        action = function()
            state.switch(game)
        end,
    },
}

landed.buttons = {}

function landed:init()
    for i, item in pairs(self.items) do
        table.insert(self.buttons, Button:new(item.title, 25, (50*(i-1)+110), nil, nil, font[32], item.action))
    end
end

function landed:enter()
    game.missionController:checkCompletion()
end

function landed:update(dt)

end

function landed:keypressed(key, isrepeat)
    if key == "escape" then
        state.push(pause)
    end
end

function landed:mousepressed(x, y, mbutton)
    for i, button in pairs(self.buttons) do
        button:mousepressed(x, y, mbutton)
    end
end

function landed:draw()
    love.graphics.setFont(fontBold[40])
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(the.player.planet.name, 25, 25)

    for i, button in pairs(self.buttons) do
        button:draw()
    end
end