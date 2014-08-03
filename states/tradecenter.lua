tradecenter = {}

tradecenter.items = {
    {
        title = "LEAVE",
        action = function()
            state.switch(landed)
        end,
    },
}

tradecenter.buttons = {}
tradecenter.commButtons = {}

function tradecenter:init()
    self.selectedCommodity = nil

    for i, item in pairs(self.items) do
        table.insert(self.buttons, Button:new(item.title, 25, 50*(i-1)+600, nil, nil, font[32], item.action))
    end

    self.commodities = {
        "Equipment",
        "Medical Supplies",
        "Ore",
        "Metal",
    }

    self.commodityPrices = {
        ["Equipment"] = 200,
        ["Medical Supplies"] = 350,
        ["Ore"] = 125,
        ["Metal"] = 160,
    }

    for i, comm in pairs(self.commodities) do
        table.insert(self.commButtons, Button:new(comm, 25, 50*(i-1)+100, nil, nil, font[32], function()
            self.selectedCommodity = comm
        end))
    end

    table.insert(self.buttons, Button:new("BUY", 25, 350, nil, nil, font[32], function()
        if self.selectedCommodity ~= nil then

            local amount = 1 --ton
            local canPay = the.player.credits >= self.commodityPrices[self.selectedCommodity] * amount
            local canHold = the.player.ship.maxCargo > the.player.ship:getCargoMass()

            if canPay and canHold then
                the.player.ship:addCargo(self.selectedCommodity, amount)

                the.player.credits = the.player.credits - self.commodityPrices[self.selectedCommodity] * amount
            end
        end
    end))

    table.insert(self.buttons, Button:new("SELL", 125, 350, nil, nil, font[32], function()
        if self.selectedCommodity ~= nil then

            local amount = 1 --ton
            local canSell = the.player.ship:getCommodityMass(self.selectedCommodity) > 0

            if canSell then
                the.player.ship:removeCargo(self.selectedCommodity, amount)
        
                the.player.credits = the.player.credits + self.commodityPrices[self.selectedCommodity] * amount
            end
        end
    end))
end

function tradecenter:enter()
    self.selectedCommodity = nil
end

function tradecenter:update(dt)

end

function tradecenter:keypressed(key, isrepeat)

end

function tradecenter:mousepressed(x, y, mbutton)
    for i, button in pairs(self.buttons) do
        button:mousepressed(x, y, mbutton)
    end

    for i, button in pairs(self.commButtons) do
        button:mousepressed(x, y, mbutton)
    end
end

function tradecenter:draw()
    love.graphics.setFont(fontBold[40])
    love.graphics.print(the.player.planet.name..' > TRADE CENTER', 25, 25)

    for i, button in pairs(self.buttons) do
        button:draw()
    end

    for i, button in pairs(self.commButtons) do
        local commodity = button.text

        if commodity == self.selectedCommodity then
            button:setBG(127, 127, 127, 127)
        else
            button:setBG(0, 0, 0, 0)
        end

        button:draw()

        love.graphics.print(the.player.ship:getCommodityMass(commodity)..' TONS', 450, button.y)
        love.graphics.print(self.commodityPrices[commodity]..'c', 350, button.y)
    end

    love.graphics.print(the.player.ship.maxCargo - the.player.ship:getCargoMass()..' TONS AVAILABLE', 450, 300)

    love.graphics.print(the.player.credits..' credits', 25, 400)
end