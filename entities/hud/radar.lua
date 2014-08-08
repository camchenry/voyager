Radar = class('Radar')

function Radar:initialize()
    self.x = 90
    self.y = love.window.getHeight() - 90
	
	self.radius = 80 -- Size of the radar on-screen
	self.range = 2500 -- How far the radar can accurately scan before a point is put on the edge
end

function Radar:update(dt)

end

function Radar:findLocal(x1, y1, x2, y2, iconRadius)
	local dx = x1 - x2
	local dy = y1 - y2
	
	-- Finds percentage of distance to an object over range of the radar, then converts to radar location
	local radarX = (dx/self.range)*self.radius
	local radarY = (dy/self.range)*self.radius
	
	 -- Checks if the point is off the radar, and puts it on the edge if it is
	local dist = math.dist(0, 0, radarX, radarY)
	if dist > (self.radius - iconRadius) then -- Checks distance in radar coordinates, compares to size of the radar
		local angle = math.angle(0, 0, radarX, radarY)
		
		-- radius is off by a few pixels to compensate for the size of the radar dots
		radarX = math.cos(angle) * (self.radius - iconRadius)
		radarY = math.sin(angle) * (self.radius - iconRadius)
	end
	
	return radarX, radarY
end

function Radar:draw()
    -- Radar circle
    love.graphics.setLineWidth(6)
    love.graphics.setColor(44, 44, 44, 255)
    love.graphics.circle("line", self.x, self.y, self.radius+3)
    love.graphics.setColor(44, 44, 44, 200)
    love.graphics.circle("fill", self.x, self.y, self.radius)

	
	
	local x, y = the.player.ship.body:getPosition() -- Location of the ship in world coordinates
	
    -- Radar objects and entities
    love.graphics.setColor(255, 255, 255)
    if the.system.objects ~= nil then
		-- Draw planets on radar
        for k, planet in pairs(the.system.objects) do
			local iconRadius = 4
			local radarX, radarY = self:findLocal(x, y, planet.x, planet.y, iconRadius)
			
			-- Draws the point relative to the center of the radar
			love.graphics.circle("fill", self.x - radarX, self.y - radarY, iconRadius)
		end
    end
	

    if the.system.entities ~= nil then
		--love.graphics.setColor(237, 66, 47)
		love.graphics.setColor(99, 99, 99)
        for k, entity in pairs(the.system.entities) do
			local iconRadius = 2
            local entX, entY = entity.x or entity.body:getX(), entity.y or entity.body:getY()
			
            -- Draw other ships on radar
			local radarX, radarY = self:findLocal(x, y, entX, entY, iconRadius)
			
            love.graphics.circle("fill", self.x - radarX, self.y - radarY, iconRadius)
		end
    end

	
    -- center point
	--love.graphics.setColor(82, 217, 235)
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", self.x, self.y, 1)
end