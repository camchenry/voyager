List = class('List')

function List:initialize(prefix, options, x, y, w, h)
	self.x = x
	self.y = y

	self.font = font[22]
	
	self.prefix = prefix
	self.text = ''
	self.options = options
	self.selected = 1
	
	self.w = w or self.font:getWidth(self.prefix.. ': ' ..self.text)
	self.h = h or self.font:getHeight()
end

function List:draw()
	local r, g, b, a = love.graphics.getColor()
    local oldColor = {r, g, b, a}
	
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(self.font)


	love.graphics.setColor(255, 255, 255)
	love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
	
	love.graphics.setColor(0, 0, 0)
	
	love.graphics.print(self.prefix.. ': ' ..self.text, self.x, self.y)
	
	love.graphics.setColor(oldColor)
	love.graphics.setFont(oldFont)
end

function List:mousepressed(x, y, button)
	if x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
		if button == 'l' then
			self.selected = self.selected < #self.options and self.selected + 1 or 1
			self:setText()
		elseif button == 'r' then
			self.selected = self.selected > 1 and self.selected - 1 or #self.options
			self:setText()
		end
	end
end


-- Takes a value, serches for an identical value's index, and selects it
function List:selectValue(value)
	for i = 1, #self.options do
		if value == self.options[i] then
			self.selected = i
		end
	end
end

-- Takes a table and searches through all options. Selects index if a match is found
function List:selectTable(tbl1)
	for i = 1, #self.options do
		local tbl2 = self.options[i]
		
		local clear = true
		for j = 1, #tbl2 do
			if tbl1[j] ~= tbl2[j] then
				clear = false
			end
		end
		
		if clear then
			self.selected = i
			break
		end
	end
end

-- Sets how options are displayed. ex: for resolution, 'val1 x val2', or for antialiasing, 'valx'
function List:setText(text)
	if not text then text = self.originalText end
	self.originalText = text

	-- Use val for simple numbered options
	if string.find(text, 'val') then text = string.gsub(text, 'val', self.options[self.selected]) end

	-- Use val1, 2 etc for table options
	if string.find(text, 'val1') then text = string.gsub(text, 'val1', self.options[self.selected][1]) end
	if string.find(text, 'val2') then text = string.gsub(text, 'val2', self.options[self.selected][2]) end
	
	self.text = text
	self.w = w or self.font:getWidth(self.prefix.. ': ' ..self.text)
end