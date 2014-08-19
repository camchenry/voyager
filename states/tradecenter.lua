tradecenter = {}

tradecenter.buttons = {}
tradecenter.commButtons = {}

tradecenter.commodityPrices = {
    ["Equipment"] = 200,
    ["Medical Supplies"] = 350,
    ["Ore"] = 125,
    ["Metal"] = 160,
}

tradecenter.commodities = {
    "Equipment",
    "Medical Supplies",
    "Ore",
    "Metal",
}

function tradecenter:init()
    self.selectedCommodity = nil

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

    self.leaveButton = Button:new("< LEAVE", 25, love.window.getHeight()-80, nil, nil, font[32], function() state.switch(landed) end)
    table.insert(self.buttons, self.leaveButton)
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
	
	
	love.graphics.setLineWidth(4)

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
		
		--[[
		for i = 1, the.player.ship:getCommodityMass(commodity) do
			love.graphics.setColor(255, 0, 0)
			love.graphics.rectangle('fill', 670+50*i, button.y+16, 32, 32)
			love.graphics.setColor(255, 255, 255)
			love.graphics.rectangle('line', 670+50*i, button.y+16, 32, 32)
		end
		]]
    end

    love.graphics.print(the.player.ship.maxCargo - the.player.ship:getCargoMass()..' TONS AVAILABLE', 450, 300)
	
	
	
	local w, h = 32, 32
	local columns = math.floor((600 - 300) / 50)
	
	local num = the.player.ship.maxCargo -- - the.player.ship:getCargoMass()
	
	local rows = math.ceil(num/columns)
	
	local commodityMasses = {}
	for i = 1, #self.commodities do
		commodityMasses[i] = the.player.ship:getCommodityMass(self.commodities[i]) 
	end
	commodityMasses[1] = commodityMasses[1] +1 --baaaad
	
	for column = 1, columns do
		for row = 1, rows do
			local number = columns*(row-1)+column
			
			if row < rows or number <= num then
			
				local x, y = 250+50*column, 350+8-50+50*row
			
				love.graphics.setColor(167, 167, 167)
				
				-- baaaaad
				if commodityMasses[4] + commodityMasses[3] + commodityMasses[2] + commodityMasses[1] <= number then love.graphics.setColor(87, 79, 94)
				elseif commodityMasses[3] + commodityMasses[2] + commodityMasses[1]  <= number then love.graphics.setColor(147, 59, 235)
				elseif commodityMasses[2] + commodityMasses[1] <= number then love.graphics.setColor(245, 212, 64)
				elseif commodityMasses[1] <= number then love.graphics.setColor(255, 0, 0) end
				
				love.graphics.rectangle('fill', x, y, 32, 32)
				love.graphics.setColor(255, 255, 255)
				love.graphics.rectangle('line', x, y, 32, 32)
			end
		end
	end
	
	love.graphics.print(columns..'x'..rows, 5, 5)

    love.graphics.print(the.player.credits..' credits', 25, 400)
end