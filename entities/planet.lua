-- represents a Planet and any data relevant to ways you can interact with it

Planet = class("Planet")

function Planet:initialize()
    self.name = name
    self.x = 0
    self.y = 0

    self.radius = 90
    self.width = self.radius*2
    self.height = self.radius*2
	
	--self.shader = love.graphics.newShader('shaders/planet.glsl')
	--self.shader:send('rand', math.random())
	
	self.seed = math.random(1000000)
	
	self.img = love.graphics.newImage('img/download.png')
	
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

end



function Planet:draw()
    love.graphics.setColor(255, 255, 255)
	--love.graphics.setShader(self.shader)
    --love.graphics.circle("fill", self.x, self.y, self.radius)
	--love.graphics.setShader()
	love.graphics.draw(self.img, self.x-self.radius, self.y-self.radius, 0, self.width/self.img:getWidth(), self.height/self.img:getHeight())
end