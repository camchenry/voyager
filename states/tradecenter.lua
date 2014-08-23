tradecenter = {}

tradecenter.buttons = {}
tradecenter.commButtons = {}

function tradecenter:init()
    self.selectedCommodity = nil

    self.sideMargin = 25
    self.bottomMargin = 100
    self.topMargin = 120

    self.sidebarWidth = math.max(250, math.floor(love.window.getWidth()/4))

    self.width = love.window.getWidth() - self.sideMargin*2 - self.sidebarWidth
    self.height = love.window.getHeight() - (self.bottomMargin+self.topMargin)

    self.defaultFont = font[22]
    self.listingFont = font[20]

    for i, comm in pairs(the.economy.commodities) do
        local button = Button:new(comm, 25, 35*(i-1)+self.topMargin, self.width, 35, self.listingFont, function()
            self.selectedCommodity = comm
        end)
        button:align('left')
        button.hoverBG = {33, 33, 33}

        table.insert(self.commButtons, button)
    end

    self.buyButton = Button:new("BUY", self.sideMargin+self.width, self.height+(self.topMargin-100), self.sidebarWidth/2, 100, font[36], function()
        if self.selectedCommodity ~= nil then

            local amount = 1 --ton
            local canPay = the.player.credits >= the.economy.prices[self.selectedCommodity] * amount
            local canHold = the.player.ship.maxCargo > the.player.ship:getCargoMass()

            if canPay and canHold then
                the.player.ship:addCargo(self.selectedCommodity, amount)

                the.player.credits = the.player.credits - the.economy.prices[self.selectedCommodity] * amount
            end
        end
    end)
    self.buyButton:setBG(33, 33, 33)
    table.insert(self.buttons, self.buyButton)

    self.sellButton = Button:new("SELL", self.sideMargin+self.width+self.sidebarWidth/2, self.height+(self.topMargin-100), self.sidebarWidth/2, 100, font[36], function()
        if self.selectedCommodity ~= nil then

            local amount = 1 --ton
            local canSell = the.player.ship:getCommodityMass(self.selectedCommodity) > 0

            if canSell then
                the.player.ship:removeCargo(self.selectedCommodity, amount)
        
                the.player.credits = the.player.credits + the.economy.prices[self.selectedCommodity] * amount
            end
        end
    end)
    self.sellButton:setBG(44, 44, 44)
    table.insert(self.buttons, self.sellButton)

    self.leaveButton = Button:new("< LEAVE", 25, love.window.getHeight()-80, nil, nil, font[32], function() state.switch(landed) end)
    table.insert(self.buttons, self.leaveButton)
end

function tradecenter:enter()
    self.selectedCommodity = nil
end

function tradecenter:update(dt)

end

function tradecenter:keypressed(key, isrepeat)
    if key == "u" then
        the.economy:update()
    end
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
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(fontBold[40])
    love.graphics.print(the.player.planet.name..' > TRADE CENTER', 25, 25)

    love.graphics.setFont(font[40])
    local text = the.player.credits..' CREDITS'
    love.graphics.print(text, love.window.getWidth() - love.graphics.getFont():getWidth(text)-25, 25)
	
	love.graphics.setLineWidth(1)

    -- border rectangle
    local x = self.sideMargin   
    local y = self.topMargin
    love.graphics.rectangle("line", x, y, self.width, self.height)

    -- divider lines and labels
    local dividers = {0, 200, 300}
    local labels = {"NAME", "PRICE", "QTY OWNED"}
    for k, x in ipairs(dividers) do
        love.graphics.line(self.sideMargin+x, self.topMargin, self.sideMargin+x, self.topMargin+self.height)

        love.graphics.setFont(fontLight[16])
        love.graphics.print(labels[k], self.sideMargin+x+5, self.topMargin-25)
    end


    for i, button in pairs(self.commButtons) do
        local commodity = button.text

        love.graphics.line(self.sideMargin, button.y, self.sideMargin+self.width, button.y)

        if commodity == self.selectedCommodity then
            button:setBG(127, 127, 127, 127)
        elseif button:hover() then
            button:setBG(33, 33, 33, 127)
        else
            button:setBG(0, 0, 0, 0)
        end

        button:draw()

        love.graphics.print(the.player.ship:getCommodityMass(commodity)..' TONS', 330, button.y)
        love.graphics.print(the.economy.prices[commodity]..' CR', 230, button.y)
    end

    -- selected commodity sidebar
    if self.selectedCommodity ~= nil then
        x = x+self.width
        love.graphics.rectangle("line", x, y, self.sidebarWidth, self.height)

        local price = the.economy.prices[self.selectedCommodity]
        local amount = the.player.ship:getCommodityMass(self.selectedCommodity)

        love.graphics.setFont(fontBold[28])
        love.graphics.print(self.selectedCommodity, x+5, y)

        love.graphics.setFont(fontLight[18])
        love.graphics.print(price..' CREDITS / TON', x+5, y+35)

        love.graphics.setFont(fontBold[24])
        love.graphics.print(price*amount..' CREDITS',x+5, y+90)

        love.graphics.setFont(fontLight[18])
        love.graphics.print('OWNED VALUE', x+5, y+115)

        -- price history
        love.graphics.line(x, y+self.height-300, x+self.sidebarWidth, y+self.height-300)

        local graphY = y+self.height-300

        local history = the.economy.priceHistory[self.selectedCommodity]
        local top = math.max(unpack(history))
        local bottom = math.min(unpack(history))
        local middle = math.ceil((top+bottom)/2)

        local yValues = {}
        local step = self.sidebarWidth / #history

        for i=1, #history do
            local diff = history[i] - middle
            local ratio = diff/(top-bottom)

            table.insert(yValues, ratio*100)
        end

        for i, y in ipairs(yValues) do
            if i ~= #yValues then
                local nextY = yValues[i+1]
                love.graphics.line(x+(i-1)*step, graphY-y+49, x+i*step, graphY-nextY+49)
            end
        end

        love.graphics.setColor(127, 127, 127)

        -- middle line
        love.graphics.line(x, graphY+50, x+self.sidebarWidth, graphY+50)

        -- outline of graph text
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(fontLight[19])
        love.graphics.print(top, x+5, graphY-5)
        love.graphics.print(bottom, x+5, graphY+100-love.graphics.getFont():getHeight(bottom))

        -- minimum and maximum graph labels
        love.graphics.setColor(127, 127, 127)
        love.graphics.setFont(fontLight[18])
        love.graphics.print(top, x+5, graphY-5)
        love.graphics.print(bottom, x+5, graphY+100-love.graphics.getFont():getHeight(bottom))

        love.graphics.setColor(255, 255, 255)

        -- average price
        love.graphics.setFont(font[18])
        local text = 'AVG PRICE: '..the.economy:getCommodityAverage(self.selectedCommodity)..' CR'
        love.graphics.print(text, x+5, graphY-love.graphics.getFont():getHeight(text))


        -- available cargo figure
        love.graphics.line(x, y+self.height-200, x+self.sidebarWidth, y+self.height-200)

        love.graphics.setColor(200, 200, 200)
        local ratio = the.player.ship:getCargoMass() / the.player.ship.maxCargo
        love.graphics.rectangle("fill", x, y+self.height-200, self.sidebarWidth*ratio, 50)
        local text = (the.player.ship.maxCargo-the.player.ship:getCargoMass()) .. ' TONS AVAILABLE'
        love.graphics.setColor(127, 127, 127)
        love.graphics.setFont(self.defaultFont)
        love.graphics.print(text, x+self.sidebarWidth/2-self.defaultFont:getWidth(text)/2, y+self.height-175-self.defaultFont:getHeight(text)/2)

        -- quantity stored figure
        love.graphics.line(x, y+self.height-150, x+self.sidebarWidth, y+self.height-150)

        love.graphics.setColor(200, 200, 200)
        local ratio = the.player.ship:getCommodityMass(self.selectedCommodity) / the.player.ship.maxCargo
        love.graphics.rectangle("fill", x, y+self.height-150, self.sidebarWidth*ratio, 50)
        local text = the.player.ship:getCommodityMass(self.selectedCommodity) .. ' TONS ON SHIP'
        love.graphics.setColor(127, 127, 127)
        love.graphics.setFont(self.defaultFont)
        love.graphics.print(text, x+self.sidebarWidth/2-self.defaultFont:getWidth(text)/2, y+self.height-125-self.defaultFont:getHeight(text)/2)
            
        -- buy and sell buttons
        love.graphics.line(x, y+self.height-100, x+self.sidebarWidth, y+self.height-100)

        self.buyButton:draw()
        self.sellButton:draw()
    end

    self.leaveButton:draw()
	
	
	--[[
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
			
				local x, y = 250+32*column, 350+8-50+32*row
			
				love.graphics.setColor(167, 167, 167)
				
				-- baaaaad
				if commodityMasses[4] + commodityMasses[3] + commodityMasses[2] + commodityMasses[1] <= number then love.graphics.setColor(87, 79, 94)
				elseif commodityMasses[3] + commodityMasses[2] + commodityMasses[1]  <= number then love.graphics.setColor(147, 59, 235)
				elseif commodityMasses[2] + commodityMasses[1] <= number then love.graphics.setColor(245, 212, 64)
				elseif commodityMasses[1] <= number then love.graphics.setColor(255, 0, 0) end
				
				love.graphics.rectangle('fill', x, y, 32, 32)
			end
		end
	end]]
end