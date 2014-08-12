-- represents a Planet and any data relevant to ways you can interact with it

Planet = class("Planet")

function Planet:initialize()
    self.name = name
    self.x = 0
    self.y = 0

    self.radius = 90
    self.width = self.radius*2
    self.height = self.radius*2
	
	self.shader = love.graphics.newShader('shaders/planet.glsl')
	--self.shader:send('rand', math.random())
	self.time = 0
	
	self.seed = math.random(1000000)
	
	self.img = nil
	
	self.color = {49, 193, 222}
end

function Planet:canLand(ship)
	local x, y = ship.body:getPosition()
	-- Checks if the ship is close enough to the planet to land (in a square bounding box)
	if x >= self.x - self.radius - 10 and x <= self.x + self.radius + 10 then
		if y >= self.y - self.radius - 10 and y <= self.y + self.radius + 10 then
			return true
		end
	end
end

function Planet:isHabitable()
    return true
end



function Planet:mapPixel(x, y, r, g, b, a)
    if r == 0 and g == 0 and b == 0 and a == 0 then
		r, g, b, a = self.imgData:getPixel(x+1, y+1)
	end
	
    return r, g, b, a
end

function Planet:update(dt)
	self.time = self.time+dt/4
	self.shader:send('time', self.time)

	if not self.img then
		self.imgData = love.image.newImageData(self.width, self.height)
		
		for x1 = 0, self.width-1 do
			for y1 = 0, self.height-1 do
				if x1 == 0 or x1 == self.width-1 or y1 == 0 or y1 == self.height-1 then
					local angle = math.angle(x1, y1, self.radius+.5, self.radius+.5)
				
					local value = 0
					local stopped = false
					local k = 1
					while stopped == false do
						k = k + 1
						
						local x = self.radius+.5 + math.cos(angle) * k
						local y = self.radius+.5 + math.sin(angle) * k
						
						local remainderX = x%1
						local remainderY = y%1
						if remainderX >= .5 then
							x = math.ceil(x)
						else
							x = math.floor(x)
						end
						if remainderY >= .5 then
							y = math.ceil(y)
						else
							y = math.floor(y)
						end
						
						if x < 0 or x > self.width-1 or y < 0 or y > self.height-1 then
							stopped = true
						--elseif math.dist(x, y, self.radius+.5, self.radius+.5) > self.radius then
						--	self.imgData:setPixel(x, y, 1, 0, 0, 0)
						--	stopped = true
						else
							local noise1 = love.math.noise((self.x+x)/80, (self.y+y)/80, self.seed)
							local noise2 = love.math.noise((self.x+x)/60, (self.y+y)/60, self.seed)
							local noise3 = love.math.noise((self.x+x)/40, (self.y+y)/40, self.seed)
							local noise4 = love.math.noise((self.x+x)/20, (self.y+y)/20, self.seed)
							
							local noise = (noise1+noise2+noise3+noise4)/4
							--value = value/2+noise/2
							value = noise
							
							local value = x > self.radius and value or noise
							--[[
							r, g, b = 48, 227, 84
							if value >= .75 then r, g, b = 158, 90, 22 
							elseif value >= .5 then r, g, b = 222, 222, 67
							elseif value >= .25 then r, g, b = 176, 227, 48
							end
							]]
							--local r, g, b = self.color[1], self.color[2], self.color[3]
							--r, g, b = r/2+(value*255/2), g/2+(value*255/2), b/2+(value*255/2)
							local r, g, b = 27, 79, 191
							if value > .9 then r, g, b = 39, 115, 24
							elseif value > .7 then r, g, b = 55, 184, 64
							elseif value > .54 then r, g, b = 235, 235, 171
							elseif value > .5 then r, g, b = 168, 201, 240
							elseif value > .4 then r, g, b = 106, 130, 222
							end
							
							self.imgData:setPixel(x, y, r, g, b, 255)
						end
					end
				end
			end
        end
		
		self.imgData:mapPixel(function (x, y, r, g, b, a)
			if r == 0 and g == 0 and b == 0 and a == 0 then
				local colors = {}
				for ix = -1, 1 do
					for iy = -1, 1 do
						local x2, y2 = x+ix, y+iy
						if x2 < 0 then x2 = self.width-1 end
						if x2 > self.width-1 then x2 = 0 end
						if y2 < 0 then y2 = self.height-1 end
						if y2 > self.height-1 then y2 = 0 end
						
						local r, g, b = self.imgData:getPixel(x2, y2)
						table.insert(colors, {r, g, b})
					end
				end
				local r, g, b = 0, 0, 0
				for k, color in pairs(colors) do
					r, g, b = (r+color[1])/2, (g+color[2])/2, (b+color[3])/2
				end
			end
			return r, g, b, a
		end)
		
		self.img = love.graphics.newImage(self.imgData)
	end
end



function Planet:draw()
    love.graphics.setColor(255, 255, 255)
	love.graphics.setShader(self.shader)
    --love.graphics.circle("fill", self.x, self.y, self.radius)
	love.graphics.draw(self.img, self.x-self.radius, self.y-self.radius)
	love.graphics.setShader()
end