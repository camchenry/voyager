starmap = {}

function starmap:init()
    self.rawSystemData = require 'data.systems'

    self.translateX = love.window.getWidth()/2
    self.translateY = love.window.getHeight()/2

    self.mouseX = 0
    self.mouseY = 0
	
	self.maxDist = 600
end

function starmap:enter()
    -- entering the starmap again shouldn't reset the translation if you have a system selected
    if self.selectedSystem == nil then
        self.translateX = love.window.getWidth()/2 - the.system.x
        self.translateY = love.window.getHeight()/2 - the.system.y
    end
	
	self.centerX, self.centerY = love.window.getWidth()/2, love.window.getHeight()/2

    self.mouseX = 0
    self.mouseY = 0

    love.mouse.setVisible(false)
	
	self.first = true
    self.hoveredSystem = nil
end

function starmap:leave()
    love.mouse.setVisible(true)
end

function starmap:focus(f)
	if f then self.first = true end
end

function starmap:angleTo(system)
    local x1, y1 = self.rawSystemData[the.player.location].x, self.rawSystemData[the.player.location].y
    local x2, y2 = self.rawSystemData[system].x, self.rawSystemData[system].y
    return math.atan2(y2 - y1, x2 - x1)
end

function starmap:update(dt)
    local centerX, centerY = self.centerX, self.centerY
    if love.window.hasMouseFocus() then -- Prevents the mouse being grabbed by the game while alt-tabbing
		love.mouse.setPosition(centerX, centerY)
	end

	local mouseX, mouseY = love.mouse.getX(), love.mouse.getY()
	if self.first then -- The first time through, the mouse will always be at the center of the screen
		self.first = false
		mouseX, mouseY = centerX, centerY
	end
	
	-- prevents starmap scrolling quickly if mouse is off-screen when the starmap is opened
	if mouseX <= 0 or mouseX >= love.window.getWidth()-1 or mouseY <= 0 or mouseY >= love.window.getHeight()-1 then
		mouseX, mouseY = centerX, centerY
	end
	
    local dx, dy = 0, 0

    -- mouse can't move anything when you have selected a system
    if self.selectedSystem == nil then
        dx, dy = centerX - mouseX, centerY - mouseY
    end

	local newX = self.translateX + dx
	local newY = self.translateY + dy

	
	-- checks if distance is greater than max, sets it to max
	local dist = math.dist(centerX, centerY, newX, newY)
	if dist > self.maxDist then
		local angle = math.angle(centerX, centerY, newX, newY)
		
		newX = centerX + math.cos(angle) * (self.maxDist)
		newY = centerY +  math.sin(angle) * (self.maxDist)
	end
	
    self.translateX = newX
    self.translateY = newY

    self.mouseX = self.translateX - centerX
    self.mouseY = self.translateY - centerY

    -- check to see which system is nearest to the mouse, for hover info
    if self.selectedSystem == nil then
        for systemName, system in pairs(self.rawSystemData) do
            local dist = math.sqrt((system.x + self.translateX - mouseX)^2 + (system.y + self.translateY - mouseY)^2)

            if dist < 45 then
                self.hoveredSystem = systemName
                break
            else
                self.hoveredSystem = nil
            end
        end
    end
end

function starmap:keypressed(key, isrepeat)
    if key == "m" then
        state.pop()
    end
end

function starmap:mousepressed(x, y, button)
    if button == "l" then
        -- finds a nearby system and selects it, otherwise deselects the current system

        -- if already selected, deselect
        if self.selectedSystem ~= nil then self.selectedSystem = nil return end

        local mouseX, mouseY = self.centerX, self.centerY

        for systemName, system in pairs(self.rawSystemData) do
            local dist = math.sqrt((system.x + self.translateX - mouseX)^2 + (system.y + self.translateY - mouseY)^2)

            if dist < 45 and systemName ~= the.player.location then

                self.selectedSystem = systemName

                -- tweens the current translation towards the selected system, looks nice
                tween(0.25, self, {
                    translateX = -self.rawSystemData[self.selectedSystem].x + self.centerX,
                    translateY = -self.rawSystemData[self.selectedSystem].y + self.centerY
                    })
                break
            else
                self.selectedSystem = nil
            end
        end
    elseif button == "r" then
        self.selectedSystem = nil
    end
end

function starmap:hoverInfo(system)
    love.graphics.setColor(255, 255, 255)

    local x, y = self.rawSystemData[system].x+self.translateX, self.rawSystemData[system].y+self.translateY

    if self.selectedSystem ~= nil then
        love.graphics.setColor(0, 255, 0)
        love.graphics.circle("line", x, y, 8)

        love.graphics.setColor(255, 255, 255)
        love.graphics.setFont(fontBold[16])
        love.graphics.print("READY FOR JUMP", x + 17, y - 15)
    end

    local objects = self.rawSystemData[system].objects

    love.graphics.setFont(font[18])

    if #objects > 0 then
        love.graphics.print("PLANETS", x+17, y+10)

        for k, planet in pairs(self.rawSystemData[system].objects) do
            love.graphics.print("- "..planet.data.name, x + 25, y + 15 + (k*20))
        end
    else
        love.graphics.print("NO OBJECTS", x + 17, y + 10)
    end

    y = y + (#objects+1)*20

    local missions = game.missionController:getMissionsInSystem(system)

    if #missions > 0 then
        love.graphics.print("MISSIONS", x+17, y+25)
    
        for k, mission in pairs(game.missionController:getMissionsInSystem(system)) do 
            love.graphics.print('- '..mission.name, x+25, y+(k*25)+30)
        end
    end
end

function starmap:selectedInfo(system)

end

function starmap:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font[16])

    -- additional center indicators
    love.graphics.setColor(33, 33, 33)
    love.graphics.line(love.window.getWidth()/2, 0, love.window.getWidth()/2, love.window.getHeight())
    love.graphics.line(0, love.window.getHeight()/2, love.window.getWidth(), love.window.getHeight()/2)

    -- displays info for when you have already selected a system
    if self.selectedSystem ~= nil then
        self:hoverInfo(self.selectedSystem)
    end

    -- displays info for when you are just hovering near a system
    if self.hoveredSystem ~= nil then
        self:hoverInfo(self.hoveredSystem)
    end

    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)

    -- draw systems
    love.graphics.push()
    love.graphics.translate(self.translateX, self.translateY)

    for systemName, system in pairs(self.rawSystemData) do
        love.graphics.setColor(255, 255, 255)

        love.graphics.circle("line", system.x, system.y, 10)
        love.graphics.setFont(fontLight[16])

        love.graphics.print(systemName, system.x+20, system.y-35)

        -- current location indicator
        if systemName == the.system.name then
            love.graphics.setColor(0, 255, 255)
            love.graphics.circle("fill", system.x, system.y, 5)
        -- selected system jump line
        elseif systemName == self.selectedSystem then
            love.graphics.setColor(255, 255, 255, 33)
            love.graphics.line(system.x, system.y, the.system.x, the.system.y)
        end

        -- line for text to sit on
        love.graphics.setColor(200, 200, 200)
        love.graphics.line(system.x+7, system.y-7, system.x+15, system.y-12, system.x+love.graphics.getFont():getWidth(systemName)+17, system.y-12)

        -- active mission arrow
        local missions = game.missionController:getMissionsInSystem(systemName)
        if #missions > 0 then
            love.graphics.setColor(240, 35, 17)
            love.graphics.polygon("fill", system.x-5, system.y-25, system.x+5, system.y-25, system.x, system.y-15)
        end
    end

    love.graphics.pop()

    -- center indicator
    local centerX, centerY = self.centerX, self.centerY
    love.graphics.circle("line", centerX, centerY, 2)

    -- x and y text
    love.graphics.setFont(font[24])
    love.graphics.print(self.translateX-centerX..', '..self.translateY-centerY)
end
