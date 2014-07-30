Checkbox = class('Checkbox')

function Checkbox:initialize(text, x, y, w, h, ox, oy)
	self.text = text
	self.font = font[32]
	self.x = x
	self.y = y -- This centers it on the line
	self.width = w or 32
	self.height = h or 32
	
	self.color = {8, 70, 120}
	self.active = {230, 115, 39}
	
	self.textColor = {0, 0, 0}
	
	self.selected = false
	
	self.activated = function() end
	self.deactivated = function() end
end

function Checkbox:draw()
	local r, g, b, a = love.graphics.getColor()
    local oldColor = {r, g, b, a}
	
	if self.selected then
		love.graphics.setColor(self.active)
	else
		love.graphics.setColor(self.color)
	end
	
	local x = self.x
	local y = self.y + self.height/2 - self.font:getHeight(self.text)/2
	
    love.graphics.rectangle("fill", x, y, self.width, self.height)
	
	love.graphics.setColor(255, 255, 255)
	
	local textWidth = self.font:getWidth(self.text)
	local textX = x - textWidth - 5
	love.graphics.setFont(self.font)
	love.graphics.setColor(self.textColor)
	love.graphics.print(self.text, textX, self.y)
	
	love.graphics.setColor(oldColor)
end

function Checkbox:mousepressed(x, y)
	if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height then
		if self.selected == false then
			self.selected = true
			self.activated()
		else
			self.selected = false
			self.deactivated()
		end
	end
end