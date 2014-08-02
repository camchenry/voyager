List = class('List')

function List:initialize(text, options, x, y, w, h)
	self.x = x
	self.y = y

	self.font = font[22]
	
	self.w = w or self.font:getWidth(text .. ': 1111 X 2222')
	self.h = h or self.font:getHeight()
	
	self.text = text
	self.options = options
	self.selected = 1
end

function List:draw()
	local r, g, b, a = love.graphics.getColor()
    local oldColor = {r, g, b, a}
	
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(self.font)


	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.print(self.text .. ': ' .. self.options[self.selected][1] .. ' x ' .. self.options[self.selected][2], self.x, self.y)
	
	love.graphics.setColor(oldColor)
	love.graphics.setFont(oldFont)
end

function List:mousepressed(x, y, button)
	if x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
		if button == 'l' then
			self.selected = self.selected < #self.options and self.selected + 1 or 1
		elseif button == 'r' then
			self.selected = self.selected > 1 and self.selected - 1 or #self.options
		end
	end
end