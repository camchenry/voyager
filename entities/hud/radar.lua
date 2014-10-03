Radar = class('Radar')

function Radar:initialize()
    self.x = 0
    self.y = 0
	
	self.range = 5000 -- How far the radar can accurately scan before a point is put on the edge
end

function Radar:update(dt)
    -- Size of the radar on-screen
    self.radius = love.window.getHeight()/2 - 100

    self.x = love.graphics.getWidth()/2
    self.y = love.window.getHeight()/2
end

function Radar:findLocal(x1, y1, x2, y2, iconRadius)
    local radarX, radarY = 0, 0

	 -- Checks if the point is on the screen and if not puts it on the radar
	local dist = math.dist(x1, y1, x2, y2)
    if (x2+game.translateX >= 0 and x2+game.translateX <= love.graphics.getWidth() and y2+game.translateY >= 0 and y2+game.translateY <= love.graphics.getHeight()) then
        radarX, radarY = x2, y2
	else
        local angle = math.atan2(y2 - y1, x2 - x1)

        radarX = math.cos(angle)*(self.radius-iconRadius) + x1
        radarY = math.sin(angle)*(self.radius-iconRadius) + y1
	end
	
    return radarX, radarY
end

function Radar:draw()
    -- Radar circle
    love.graphics.setLineWidth(1)

    if the.player.ship.destroyed then return end
    
	local x, y = the.player.ship.body:getPosition() -- Location of the ship in world coordinates
	
    -- Radar objects and entities
    love.graphics.setColor(255, 255, 255, 200)
    if the.system.objects ~= nil then
		-- Draw planets on radar
        for k, planet in pairs(the.system.objects) do
            local ratio = 1500 / math.dist(x, y, planet.x, planet.y)
            -- radius can be no bigger than 16, and no smaller than 4
            local iconRadius = math.min(math.max(ratio*16, 4), 16)
			local radarX, radarY = self:findLocal(x, y, planet.x, planet.y, iconRadius)

			-- Draws the point relative to the center of the radar
			love.graphics.circle("fill", radarX+game.translateX, radarY+game.translateY, iconRadius)

            for i, mission in pairs(game.missionController:getActiveMissions()) do
                if mission.destination == planet.name then
                    love.graphics.push()
                    love.graphics.translate(game.translateX, game.translateY)
                    love.graphics.setColor(240, 35, 17, 225)
                    love.graphics.polygon("fill", radarX-7, radarY-35, radarX+7, radarY-35, radarX, radarY-20)
                    love.graphics.pop()
                    love.graphics.setColor(255, 255, 255)
                    break
                end
            end

		end
    end
	

    if the.system.entities ~= nil then
		--love.graphics.setColor(237, 66, 47)
		love.graphics.setColor(99, 99, 99)
        for k, entity in pairs(the.system.entities) do
			local iconRadius = 8
            local entX, entY = entity.x or entity.body:getX(), entity.y or entity.body:getY()
			
            -- Draw other ships on radar
			local radarX, radarY = self:findLocal(x, y, entX, entY, iconRadius)
			
            love.graphics.circle("fill", radarX+game.translateX, radarY+game.translateY, iconRadius)
		end
    end

    love.graphics.setColor(99, 99, 99, 127)

    filled_arc(self.x, self.y, self.radius, math.pi - math.pi/4, math.pi + math.pi/4, 2500)
    filled_arc(self.x, self.y, self.radius, -math.pi/4,  math.pi/4, 2500)

    love.graphics.origin()
end