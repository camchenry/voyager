Chat = class("Chat")

function Chat:initialize(x, y)
	self.font = font[20]
	self.fontHeight = self.font:getHeight()
	self.spacing = self.fontHeight - 12
	
	self.w = 340
	self.h = self.spacing*8 + self.fontHeight -- 8 lines + input line
	self.x = x or SCREEN_WIDTH - self.w - 5
	self.y = y or SCREEN_HEIGHT - self.h - 5
	
	self.leftMargin = 5
	
	self.bgColor = {94, 94, 94, 120}
	self.textColor = {255, 255, 255, 255}
	
	self.text = 'Hi man how is it go?'
	
	self.messages = {}
end

function Chat:draw()
	local oldFont = love.graphics.getFont()
	
	love.graphics.setFont(self.font)
	love.graphics.setColor(self.bgColor)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	
	love.graphics.setColor(self.textColor)
	love.graphics.print('> '..self.text, self.x + self.leftMargin, self.y+self.h - self.fontHeight)
	
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
    --if self.selected then
        self.text = self.text .. text
    --end
end

function Chat:keypressed(key, isrepeat)
    if key == "backspace" then
        self.text = string.sub(self.text, 1, -2)
    elseif key == "return" then
        --self.selected = false
		self:send()
    end
end

function Chat:send()
	if self.text ~= '' then
		gameOnline:sendToServer(self.text)
		self.text = ''
	end
end

function Chat:addMessage(str)
	table.insert(self.messages, 1, str)
end