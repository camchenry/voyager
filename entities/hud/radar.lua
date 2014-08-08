Radar = class('Radar')

function Radar:initialize()
    self.x = 90
    self.y = love.window.getHeight() - 90
	
	self.radius = 80 -- Size of the radar on-screen
	self.range = 2500 -- How far the radar can accurately scan before a point is put on the edge
end

function Radar:update(dt)

end

function Radar:findLocal(x1, y1, x2, y2)
	local dx = x1 - x2
	local dy = y1 - y2
	
	-- Finds percentage of distance to an object over range of the radar, then converts to radar location
	local radarX = (dx/self.range)*self.radius
	local radarY = (dy/self.range)*self.radius
	
	 -- Checks if the point is off the radar, and puts it on the edge if it is
	local dist = math.dist(0, 0, radarX, radarY)
	if dist > self.radius then -- Checks distance in radar coordinates, compares to size of the radar
		local angle = math.angle(0, 0, radarX, radarY)
		radarX = math.cos(angle) * self.radius
		radarY = math.sin(angle) * self.radius
	end
	
	return radarX, radarY
end

function Radar:draw()
    love.graphics.setColor(255, 255, 255)
    if the.system.objects ~= nil then
		local x, y = the.player.ship.body:getPosition() -- Location of the ship in world coordinates
	
		-- Draw planets on radar
        for k, planet in pairs(the.system.objects) do
			local radarX, radarY = self:findLocal(x, y, planet.x, planet.y)
			
			-- Draws the point relative to the center of the radar
			love.graphics.circle("fill", self.x - radarX, self.y - radarY, 4)
		end
		
		-- Draw other ships on radar
		love.graphics.setColor(237, 66, 47)
		for k, entity in pairs(the.system.entities) do
			local entX, entY = entity.body:getPosition()
			
			local radarX, radarY = self:findLocal(x, y, entX, entY)
			
            love.graphics.circle("fill", self.x - radarX, self.y - radarY, 4)
		end
		
		-- Draw the player on radar (always the center)
		love.graphics.setColor(82, 217, 235)
		love.graphics.circle("fill", self.x, self.y, 5)
    end

	love.graphics.setLineWidth(6)
    love.graphics.setColor(44, 44, 44, 255)
	love.graphics.circle("line", self.x, self.y, self.radius+3)
	love.graphics.setColor(44, 44, 44, 200)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end