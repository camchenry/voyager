options = {}

function options:enter()
    self.vsync = Checkbox:new('vsync', 50, 50)
	self.fullscreen = Checkbox:new('fullscreen', 50, 90)
	self.borderless = Checkbox:new('borderless', 50, 130)
	
	self.apply = Button:new('apply changes', 50, 200)
	self.apply.activated = function ()
		local width, height = love.window.getDesktopDimensions(1)
		
		love.window.setMode(width, height, {vsync = self.vsync.selected, fullscreen = self.fullscreen.selected, borderless = self.borderless.selected})
	end
end

function options:update(dt)

end

function options:keypressed(key, isrepeat)

end

function options:mousepressed(x, y, button)
	if button == 'l' then
		self.vsync:mousepressed(x, y)
		self.fullscreen:mousepressed(x, y)
		self.borderless:mousepressed(x, y)
	end
end

function options:draw()
	self.vsync:draw()
	self.fullscreen:draw()
	self.borderless:draw()
	
	self.apply:draw()
end
