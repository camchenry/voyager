BBS = class("BSS")

function BBS:initialize(options)
	self.options = options
	
	self.width = love.window.getWidth() - 100
	self.height = love.window.getHeight() - 200
	
	self.x = love.window.getWidth()/2 - self.width/2
	self.y = love.window.getHeight()/2 - self.height/2
	
	self.optionsDisplayed = 5
	
	self.itemWidth = self.width*2/5
	self.itemHeight = self.height/5
	self.font = font[self.itemHeight/3]
	
	self.sidebarItems = {}
	for i, option in ipairs(self.options) do
		local button = sidebarButton:new(option.name, self.x, self.y+self.itemHeight*(i-1), self.itemWidth, self.itemHeight)
		button.bg = {127, 127, 127}
		self.outlineColor = {236, 236, 236}
		button.outline = true
		button.index = i
		
		button.hovered = function (index)
			self.activeItem = index
		end
		
		self.sidebarItems[i] = button
	end
	
	self.activeItem = 1
	
	self.activeColor = {74, 232, 80}
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
	love.graphics.printf(option.name..'\n'..option.pay..'\n'..option.desc, x+5, y+5, self.width-self.itemWidth-10, 'left')
end