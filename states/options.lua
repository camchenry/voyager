options = {}

function options:init()
	self.saveFile = 'config.txt'
end

function options:enter()
	local width, height, flags = love.window.getMode()

    self.vsync = Checkbox:new('vsync', 50, 50)
	self.vsync.selected = flags.vsync
	
	self.fullscreen = Checkbox:new('fullscreen', 50, 90)
	self.fullscreen.selected = flags.fullscreen
	
	self.borderless = Checkbox:new('borderless', 50, 130)
	self.borderless.selected = flags.borderless
	
	--local resolutions = {{1024, 768}, {1600, 900}}
	local resTable = love.window.getFullscreenModes(1)
	local resolutions = {}
	for k, res in pairs(resTable) do
		if res.width >= 800 then -- cuts off any resolutions with a with under 800
			table.insert(resolutions, {res.width, res.height})
		end
	end
	
	self.resolution = List:new('resolution', resolutions, 50, 170)
	
	for i, res in ipairs(resolutions) do
		if width == res.width and height == res.height then
			self.resolution.selected = i
		end
	end
	
	
	-- applies current config settings
	self.apply = Button:new('apply changes', 50, 240)
	self.apply.activated = function ()
		local width = self.resolution.options[self.resolution.selected][1]
		local height = self.resolution.options[self.resolution.selected][2]
		
		local vsync = self.vsync.selected
		local fullscreen = self.fullscreen.selected
		local borderless = self.borderless.selected
		
		love.window.setMode(width, height, {vsync = vsync, fullscreen = fullscreen, borderless = borderless})
		
		self:save(width, height, vsync, fullscreen, borderless)
	end
end

function options:mousepressed(x, y, button)
	if button == 'l' then
		self.vsync:mousepressed(x, y)
		self.fullscreen:mousepressed(x, y)
		self.borderless:mousepressed(x, y)
	end
	
	self.resolution:mousepressed(x, y, button)
	
	self.apply:mousepressed(x, y, button)
end

function options:keypressed(key)
	if key == 'escape' then
		state.pop()
	end
end

function options:draw()
	self.vsync:draw()
	self.fullscreen:draw()
	self.borderless:draw()
	
	self.resolution:draw()
	
	self.apply:draw()
end


function options:save(width, height, vsync, fullscreen, borderless)
	local str = ''
	
	-- prepares config save data
	
	-- checkboxes
	str = str.. 'vsync: ' ..tostring(vsync).. '\n'
	str = str.. 'fullscreen: '..tostring(fullscreen).. '\n'
	str = str.. 'borderless: '..tostring(borderless).. '\n'
	
	-- resolution
	str = str.. 'screen width: ' ..tostring(width).. '\n'
	str = str.. 'screen height: ' ..tostring(height).. '\n'
	

	love.filesystem.write(self.saveFile, str)
end

function options:load()
	local saveFile = 'config.txt'
	-- self.saveFile variable couldn't be accessed from love.load where this is called

	if love.filesystem.exists(saveFile) then
		local config = {}
		local width, height = 1024, 768 -- default if a width/height not found, but the file exists

		-- iterates through each line of the config file, removes extra line data
		for line in love.filesystem.lines(saveFile) do
			if string.find(line, 'vsync: ') then config.vsync = string.gsub(line, 'vsync: ', '')
			elseif string.find(line, 'fullscreen: ') then config.fullscreen = string.gsub(line, 'fullscreen: ', '')
			elseif string.find(line, 'borderless: ') then config.borderless = string.gsub(line, 'borderless: ', '')
			
			elseif string.find(line, 'screen width: ') then width = string.gsub(line, 'screen width: ', '')
			elseif string.find(line, 'screen height: ') then height = string.gsub(line, 'screen height: ', '')
			end
		end
		
		-- converts strings to booleans
		if config.vsync == "true" then config.vsync = true
		else config.vsync = false end
		
		if config.fullscreen == "true" then config.fullscreen = true
		else config.fullscreen = false end
		
		if config.borderless == "true" then config.borderless = true
		else config.borderless = false end
		
		love.window.setMode(tonumber(width), tonumber(height), config)
		
		-- returns true if a config file exists
		return true
	end
end