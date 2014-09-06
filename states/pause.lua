pause = {}

pause.items = {
    {
        title = "RESUME GAME",
        action = function()
            state.pop()
        end,
    },

    {
        title = "OPTIONS",
        action = function()
            state.push(options)
        end,
    },

    {
        title = "QUIT",
        action = function()
            state.pop()
            state.switch(menu)
        end,
    },
}

pause.buttons = {}

function pause:init()
    self.width = 200
    self.height = 500

    self.x = love.graphics.getWidth()/2 - self.width/2
    self.y = love.graphics.getHeight()/2 - self.height/2

    for i, item in pairs(self.items) do
        table.insert(self.buttons, Button:new(item.title, self.x, self.y + 50*(i-1), nil, nil, font[32], item.action))
    end
end

function pause:enter(prev)
    self.prevState = prev

    self.x = love.graphics.getWidth()/2 - self.width/2
    self.y = love.graphics.getHeight()/2 - self.height/2
end

function pause:update(dt)

end

function pause:keypressed(key, code)
    if key == "escape" then
        state.pop()
    end
end

function pause:mousepressed(x, y, mbutton)
    for i, button in pairs(self.buttons) do
        button:mousepressed(x, y, mbutton)
    end
end

function pause:draw()
    if self.prevState ~= nil then
        self.prevState:draw()
    end

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    for i, button in pairs(self.buttons) do
        button:draw()
    end
end