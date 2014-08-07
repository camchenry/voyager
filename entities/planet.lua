-- represents a Planet and any data relevant to ways you can interact with it

Planet = class("Planet")

function Planet:initialize()
    self.name = name
    self.x = 0
    self.y = 0

    self.radius = 50
    self.width = self.radius*2
    self.height = self.radius*2
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

function Planet:update(dt)

end

function Planet:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end