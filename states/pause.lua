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
    self.width = math.max(love.graphics.getWidth()/4, 250)
    self.height = 350

    self.x = love.graphics.getWidth()/2 - self.width/2
    self.y = love.graphics.getHeight()/2 - self.height/2

    for i, item in pairs(self.items) do
        table.insert(self.buttons, Button:new(item.title, self.x + 10, self.y + 50*(i-1), nil, nil, font[32], item.action))
    end
end

function pause:positionButtons()
    for i, button in pairs(self.buttons) do
        button.x = self.x + 10
        button.y = self.y + 50*(i-1)
    end
end

function pause:enter(prev)
    self.prevState = prev

    self.width = math.max(love.graphics.getWidth()/4, 250)

    self.x = love.graphics.getWidth()/2 - self.width/2
    self.y = love.graphics.getHeight()/2 - self.height/2

    self:positionButtons()
end

function pause:update(dt)
    -- if the screen resolution changed, the menu needs to be repositioned
    if (love.graphics.getWidth() ~= self.x*2 + self.width) or (love.graphics.getHeight() ~= self.y*2 + self.height) then

        self.width = math.max(love.graphics.getWidth()/4, 250)

        self.x = love.graphics.getWidth()/2 - self.width/2
        self.y = love.graphics.getHeight()/2 - self.height/2

        self:positionButtons()
    end
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