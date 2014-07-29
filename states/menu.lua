menu = {}

menu.items = {
    {
        title = "NEW GAME",
        action = function()
            state.switch(start)
			--state.switch(gameOnline) -- Temp
        end,
    },

    {
        title = "CONTINUE",
        action = function()
            state.switch(continue)
        end,
    },

    {
        title = "OPTIONS",
        action = function()
            state.switch(options)
        end,
    },

    {
        title = "QUIT",
        action = function()
            love.event.quit()
        end,
    },
}

menu.buttons = {}

function menu:init()
    for i, item in pairs(self.items) do
        table.insert(self.buttons, Button:new(item.title, 25, 50*(i-1) + 100, nil, nil, font[32], item.action))
    end
end

function menu:enter()

end

function menu:update(dt)

end

function menu:keyreleased(key, code)

end

function menu:mousereleased(button, x, y)
    for k, button in pairs(self.buttons) do
        if button:hover() then button:activated() end
    end
end

function menu:draw()
    for i, button in pairs(self.buttons) do
        button:draw()
    end
end