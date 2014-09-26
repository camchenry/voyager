bbs = {}

function bbs:init()
	self.leaveButton = Button:new("< LEAVE", 25, love.window.getHeight()-80, nil, nil, font[32], function() state.switch(landed) end)

	self.options = game.missionController:generateMissions(the.player.planet.name)
	
	self.width = love.window.getWidth() - 50
	self.height = love.window.getHeight() - 200
	
	self.x = love.window.getWidth()/2 - self.width/2
	self.y = love.window.getHeight()/2 - self.height/2
	
	self.optionsDisplayed = 5 -- max number of options on a bbs
	
	self.itemWidth = self.width/5
	self.itemHeight = self.height/5
	self.font = font[self.itemHeight/3]
	
	self.acceptButton = Button:new('Accept', 0, 0)
	self.acceptButton:centerAround(self.x/2+self.width/2, self.y+self.height-self.acceptButton.height/2-10)
	self.acceptButton.active = {74, 232, 80}
	self.acceptButton.activated = function()
		self:acceptActiveMission()
	end
		
	self.activeIndex = nil
	self.activeMission = nil
	self.activeColor = {0, 0, 0}
end

function bbs:acceptActiveMission()
	if self.activeIndex == nil then return end

	local accepted, problem = game.missionController:acceptMission(self.activeMission)

	if not accepted then
		fx.text(3, problem, 5, 5, {255, 0, 0})
	-- only removes the mission from the list if it can be taken
	else 
		table.remove(self.options, self.activeIndex)
		self:setup()
	end

	-- select first item in options
	for i, v in pairs(self.options) do
		self.activeIndex = i
		break
	end
end

function bbs:setup()
	self.sidebarItems = {}
	for i, option in ipairs(self.options) do
		local button = sidebarButton:new(option.name, self.x, self.y+self.itemHeight*(i-1), self.itemWidth, self.itemHeight)
		button.bg = {127, 127, 127}
		
		button.activated = function ()
			self.activeIndex = i -- returns the index of the selected option
		end
		
		self.sidebarItems[i] = button
	end
end

function bbs:enter()
	self:setup()
end

function bbs:update()
	for i, button in ipairs(self.sidebarItems) do
		button:update()
	end

	if self.activeIndex ~= nil then
		self.activeMission = self.options[self.activeIndex]
	end
end

function bbs:mousepressed(x, y, mbutton)
	for i, button in ipairs(self.sidebarItems) do
		button:mousepressed(x, y, mbutton)
	end

	self.leaveButton:mousepressed(x, y, mbutton)
	self.acceptButton:mousepressed(x, y, mbutton)
end

function bbs:keypressed(key, isrepeat)
	if key == "return" then
		self:acceptActiveMission()
	end

	if key == "escape" then
		state.switch(landed)
	end
end

function bbs:draw()
	love.graphics.setFont(fontBold[40])
    love.graphics.print(the.player.planet.name..' > BBS', 25, 25)

	self.leaveButton:draw()

	love.graphics.setFont(self.font)
	
	for i, button in ipairs(self.sidebarItems) do
		if i == self.activeIndex then
			button:draw(true)
		else
			button:draw(false)
		end
	end
	
	local x, y = self.x+self.itemWidth, self.y
	
	love.graphics.setLineWidth(2)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', x, y, self.width-self.itemWidth, self.height)
	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('line', x, y, self.width-self.itemWidth, self.height)

	-- will only print option data if there is an option (at least one mission available)
	if self.activeMission ~= nil then

		love.graphics.setFont(fontBold[48])
		love.graphics.print(self.activeMission.name, x+5, y)
		
		love.graphics.setFont(fontLight[28])
		love.graphics.print('PAYMENT: '..self.activeMission.pay..'CR', x+5, y+65)

		love.graphics.setFont(font[36])
		love.graphics.print(self.activeMission.description, x+5, y+100)


		self.acceptButton:draw() -- will not draw accept button if there are no available missions
	end
end