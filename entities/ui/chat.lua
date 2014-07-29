Chat = class("Chat")

function Chat:initialize(x, y)
	self.font = font[20]
	self.fontHeight = self.font:getHeight()
	self.spacing = self.fontHeight - 12 -- prevents lines using more space than needed
	
	self.w = 340
	self.h = self.spacing*8 + self.fontHeight -- 8 lines + input line
	self.x = x or SCREEN_WIDTH - self.w - 5 -- Places it near bottom-right corner
	self.y = y or SCREEN_HEIGHT - self.h - 5
	
	self.leftMargin = 5
	
	self.bgColor = {94, 94, 94, 120}
	self.textColor = {255, 255, 255, 255}
	
	self.text = ''
	
	self.active = false
	self.messages = {}
	
	self.timer = 0
	self.switch = 1
	self.cursor = false
end

function Chat:update(dt)
	self.timer = self.timer+dt
	if self.timer >= self.switch then
		self.timer = 0
		if self.cursor then
			self.cursor = false
		else
			self.cursor = true
		end
	end
end

function Chat:draw()
	local oldFont = love.graphics.getFont()
	
	love.graphics.setFont(self.font)
	love.graphics.setColor(self.bgColor)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	
	love.graphics.setColor(self.textColor)
	
	if self.active then
		local input = '> '..self.text
		if self.cursor then input = input..'_' end
		love.graphics.print(input, self.x + self.leftMargin, self.y+self.h - self.fontHeight)
	end
	
	for i, msg in ipairs(self.messages) do
		local x = self.x + self.leftMargin
		local y = self.y+self.h - self.fontHeight - (i) * self.spacing
		if y >= self.y then
			love.graphics.print(msg, x, y)
		end
	end
	
	love.graphics.setFont(oldFont)
end


function Chat:textinput(text)
    if self.active then
        self.text = self.text .. text
		self.timer = 0 -- Cursor resets when a character is entered
		self.cursor = true
    end
end

function Chat:keypressed(key, isrepeat)
	if key == "return" then
		if self.active then
			self:send()
			self.active = false
		else
			self.active = true
		end
	elseif key == "backspace" then
        self.text = string.sub(self.text, 1, -2)
		self.timer = 0 -- Cursor resets when character removed
		self.cursor = true
    end
end

function Chat:send()
	if self.text ~= '' then
		local str = 'tx|' .. self.text
		gameOnline:sendToServer(str)
		self.text = ''
	end
end

function Chat:addMessage(str)
	table.insert(self.messages, 1, str)
end