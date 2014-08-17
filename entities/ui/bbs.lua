BBS = class("BSS")

function BBS:initialize(options)
	self.options = options
	
	self.width = love.window.getWidth() - 100
	self.height = love.window.getHeight() - 200
	
	self.x = love.window.getWidth()/2 - self.width/2
	self.y = love.window.getHeight()/2 - self.height/2
	
	self.optionsDisplayed = 5 -- max number of options on a bbs
	
	self.itemWidth = self.width*1/5
	self.itemHeight = self.height/5
	self.font = font[self.itemHeight/3]
	
	self.returnMission = function() end
	
	self:setup()
	
	self.acceptButton = Button:new('Accept', 0, 0)
	self.acceptButton:centerAround(self.x+self.width-self.acceptButton.width/2-10, self.y+self.height-self.acceptButton.height/2-10)
	self.acceptButton.active = {74, 232, 80}
	self.acceptButton.activated = function()
		delete = self.returnMission(self.options[self.activeItem])
		if delete then -- only removes the mission from the list if it can be taken
			table.remove(self.options, self.activeItem)
			self:setup()
		end
	end
	
	self.activeItem = 1
	
	self.activeColor = {74, 232, 80}
end

function BBS:setup()
	self.sidebarItems = {}
	for i, option in ipairs(self.options) do
		local button = sidebarButton:new(option.name, self.x, self.y+self.itemHeight*(i-1), self.itemWidth, self.itemHeight)
		button.bg = {127, 127, 127}
		self.outlineColor = {236, 236, 236}
		button.index = i -- sets the index so it can be returned later
		
		button.hovered = function (index)
			self.activeItem = index -- returns the index of the selected option
		end
		
		self.sidebarItems[i] = button
	end
end

function BBS:update()
	for i, button in ipairs(self.sidebarItems) do
		button:update()
	end
end

function BBS:mousepressed(x, y, mbutton)
	self.acceptButton:mousepressed(x, y, mbutton)
end

function BBS:draw()
	love.graphics.setFont(self.font)
	
	for i, button in ipairs(self.sidebarItems) do
		if i == self.activeItem then
			button:draw(true)
		else
			button:draw(false)
		end
	end
	
	local x, y = self.x+self.itemWidth, self.y
	
	love.graphics.setLineWidth(6)
	
	love.graphics.setColor(127, 127, 127)
	love.graphics.rectangle('fill', x, y, self.width-self.itemWidth, self.height)
	love.graphics.setColor(236, 236, 236)
	love.graphics.rectangle('line', x, y, self.width-self.itemWidth, self.height)
	
	local option = self.options[self.activeItem]
	if option then -- will only print option data if there is an option (at least one mission available)
		love.graphics.printf(option.name..'\n'..option.pay..'\n'..option.desc, x+5, y+5, self.width-self.itemWidth-10, 'left')
		
		self.acceptButton:draw() -- will not draw accept button if there are no available missions
	end
end