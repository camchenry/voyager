Radar = class('Radar')

function Radar:initialize()
    self.x = 90
    self.y = love.window.getHeight() - 90
	
	self.radius = 80
	self.range = 2500
end

function Radar:update(dt)

end

function Radar:draw()
    love.graphics.setColor(255, 255, 255)
    if the.system.objects ~= nil then
        for k, planet in pairs(the.system.objects) do
			local x, y = the.player.ship.body:getPosition()
			
			local dx = x - planet.x
			local dy = y - planet.y
			
			-- Finds percentage of distance to an object over range of the radar, then converts to radar location
			local radarX = (dx/self.range)*self.radius
			local radarY = (dy/self.range)*self.radius
			
			 -- Checks if the point is off the radar, and puts it on the edge if it is
			local dist = math.dist(0, 0, radarX, radarY)
			if dist > self.radius then
				local angle = math.angle(0, 0, radarX, radarY)
				radarX = math.cos(angle) * self.radius
				radarY = math.sin(angle) * self.radius
			end
			
            love.graphics.circle("fill", self.x - radarX, self.y - radarY, 3)

        -- needs entities too
		end
    end

    love.graphics.setColor(44, 44, 44, 200)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end