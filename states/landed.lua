landed = {}

landed.items = {
    {
        title = "LEAVE",

    }
}

function landed:init()
    self.leaveButton = Button:new("Leave", 0, love.window.getHeight()-50, nil, 50, nil, function()
        state.switch(game)
    end)
end

function landed:enter()
    
end

function landed:update(dt)

end

function landed:keypressed(key, isrepeat)

end

function landed:draw()
    love.graphics.print(the.player.planet.name)

    self.leaveButton:draw()
end