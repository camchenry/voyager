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
    -- Radar circle
    love.graphics.setColor(44, 44, 44, 200)
    love.graphics.circle("fill", self.x, self.y, self.radius)

    -- Radar objects and entities
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
            -- radius is off by a few pixels to compensate for the size of the radar dots
			if dist > (self.radius - 3) then
				local angle = math.angle(0, 0, radarX, radarY)

                -- radius is off by a few pixels to compensate for the size of the radar dots
				radarX = math.cos(angle) * (self.radius - 3)
				radarY = math.sin(angle) * (self.radius - 3)
			end
			
            love.graphics.setColor(99, 99, 99)
            love.graphics.circle("fill", self.x - radarX, self.y - radarY, 3)
		end
    end

    if the.system.entities ~= nil then
        for k, entity in pairs(the.system.entities) do
            local x, y = the.player.ship.body:getPosition()
            local entX, entY = entity.x or entity.body:getX(), entity.y or entity.body:getY()

            local dx = x - entX
            local dy = y - entY
            
            -- Finds percentage of distance to an entity over range of the radar, then converts to radar location
            local radarX = (dx/self.range)*self.radius
            local radarY = (dy/self.range)*self.radius
            
             -- Checks if the point is off the radar, and puts it on the edge if it is
            local dist = math.dist(0, 0, radarX, radarY)
            -- radius is off by a few pixels to compensate for the size of the radar dots
            if dist > (self.radius - 2) then
                local angle = math.angle(0, 0, radarX, radarY)

                -- radius is off by a few pixels to compensate for the size of the radar dots
                radarX = math.cos(angle) * (self.radius - 2)
                radarY = math.sin(angle) * (self.radius - 2)
            end
            
            love.graphics.setColor(0, 0, 255)
            love.graphics.circle("fill", self.x - radarX, self.y - radarY, 2)
        end
    end

    -- center point
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", self.x, self.y, 1)
end