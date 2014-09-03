game = {}

function game:init()
	self.missionController = MissionController:new()

    self.HUD = HUD:new()
    self.navigation = Navigation:new()
    self.HUD:addWidget(self.navigation)
    self.radar = Radar:new()
    self.HUD:addWidget(self.radar)

    -- by setting the game up with a reset, it ensures that resetting will 
    -- take the game back to the original state
    self:reset()
	
	self.starQuad = love.graphics.newQuad(0, 0, love.window.getWidth()*2, love.window.getHeight()*2, 512, 512)
	self.nebulaQuad = love.graphics.newQuad(0, 0, love.window.getWidth(), love.window.getHeight(), love.window.getWidth(), love.window.getHeight())
	self.starImages = {}
	for i = 1, 2 do
		self.starImages[i] = love.graphics.newImage('img/starField'..i..'.png')
		self.starImages[i]:setWrap('repeat')
	end
end

function game:reset()
    self.collision = Collision:new()
    assert(self.collision ~= nil)
    assert(Collision ~= nil)
    assert(self.collision.beginContact ~= nil)

    the.economy = Economy:new()
    for i=1, 10 do
        the.economy:update()
    end
end

function game:enter()
    -- the system will be changed to match whichever system the player is in
    the.system:load(the.player.location)
    the.system:entered()

    the.system.world:setCallbacks(self.collision.beginContact, self.collision.endContact, self.collision.preSolve, self.collision.postSolve)

    self.selectedObject = nil

    self.translateX = 0
    self.translateY = 0
end

function game:load(file, ignoreError)
    if ignoreError ~= false then ignoreError = true end

    local ok, data = pcall(love.filesystem.read, file)

    if ok then
        ok, data = pcall(loadstring('return ' .. data))
        
        if not ok then
            if ignoreError then
                data = {}
            else
                error("could not deserialize storage data: " .. self.data)
            end
        end
    else
        if not ignoreError then
            error("could not load storage from disk: " .. data)
        end
    end

    return data, ok
end

function game:update(dt)
    the.system:update(dt)
    if not the.player.ship.destroyed then
        the.player.ship:update(dt)
    else
        wait(2, state.switch, menu)
        self:reset()
    end

    if not the.player.ship.destroyed then
        self.translateX = -the.player.ship.body:getX() + love.window.getWidth()/2
        self.translateY = -the.player.ship.body:getY() + love.window.getHeight()/2
    end

    if the.player.ship.jumping then
        if the.player.ship.engagingJump then
            self.navigation:setText("ENGAGING HYPERJUMP DRIVE", "T-"..round(the.player.ship.jumpCountdown, 2))
        else
            self.navigation:setText("EXECUTING HYPERJUMP")
        end
    elseif self.selectedObject ~= nil then
        self.navigation:setText('STELLAR DESTINATION: '..string.upper(self.selectedObject.name), 'PRESS (L) TO LAND')

    elseif starmap.selectedSystem ~= nil then
        self.navigation:setText('HYPERJUMP DESTINATION: '..string.upper(starmap.selectedSystem), 'PRESS (J) TO JUMP')
    else
        self.navigation:setText('LOCATION: '..string.upper(the.system.name))
    end

    self.HUD:update(dt)
end


function game:keypressed(key, isrepeat)
    love.keyboard.setKeyRepeat(false)
    the.system:keypressed(key, isrepeat)
    if not the.player.ship.destroyed then
        the.player.ship:keypressed(key, isrepeat)
    end
    love.keyboard.setKeyRepeat(false)

    if not the.player.ship.jumping then
        if key == "m" then
            state.push(starmap)
        end

        if key == "j" then
            the.player:jump()
            self.selectedObject = nil
        end

        if key == "l" then
            if self.selectedObject ~= nil then
    			if self.selectedObject:canLand(the.player.ship) then
    				the.player.planet = self.selectedObject
    				the.player.ship:stop()
    				self.selectedObject = nil
    				state.switch(landed)
    			end
            else
                self.selectedObject = the.system:closestObject(the.player.ship.body:getX()-self.translateX, the.player.ship.body:getY()-self.translateY)
            end
        end
    end

    if key == "escape" then
        if self.selectedObject ~= nil then
            self.selectedObject = nil
        end
    end


end

function game:mousepressed(x, y, button)
    if button == "l" then
        self.selectedObject = the.system:closestObject(x-self.translateX, y-self.translateY)
    end
end

function game:draw()
    love.graphics.setColor(255, 255, 255)
	local x, y = 0, 0
	
	for i = 1, #self.starImages do
		if the.player.ship and not the.player.ship.destroyed then
			x, y = the.player.ship.body:getPosition()
			
			local divisor = (#self.starImages+1-i)*15
			x, y = math.floor(x/divisor), math.floor(y/divisor)
			local w, h = self.starImages[i]:getDimensions()
			x = x % w
			y = y % h
		end
		if i > 1 then
			love.graphics.draw(self.starImages[i], self.starQuad, -x, -y)
		else
			love.graphics.draw(self.starImages[i], self.nebulaQuad, 0, 0)
		end
	end
	
    love.graphics.translate(math.floor(self.translateX), math.floor(self.translateY))
    -- things that should be translated

    love.graphics.setColor(255, 255, 255)
    -- selected object display
    if self.selectedObject ~= nil then
        local obj = self.selectedObject

        love.graphics.rectangle("line", obj.x-obj.width/2-10, obj.y-obj.height/2-10, obj.width+20, obj.height+20)
    end

    love.graphics.origin()

    -- drawing the player with a floored translation causes the ship to look jittery
    love.graphics.translate(self.translateX, self.translateY)

    the.system:draw()
    if not the.player.ship.destroyed then
        the.player.ship:draw()
    end

    love.graphics.origin()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)

    fx.draw()

    self.HUD:draw()

    love.graphics.setLineWidth(1)
    love.graphics.setFont(font[18])

    local ratio = the.player.ship.hull / the.player.ship.maxHull

    love.graphics.setColor(127, 127, 127, 33)
    love.graphics.rectangle("fill", love.window.getWidth()/2-250, love.window.getHeight()-55, 250*2, 20)
    love.graphics.setColor(255, 66, 33, 127)
    love.graphics.rectangle("fill", love.window.getWidth()/2-250, love.window.getHeight()-55, 250*2*ratio, 20)


    love.graphics.setColor(255, 255, 255)
    local text = the.player.ship.hull .. ' / ' .. the.player.ship.maxHull
    love.graphics.print(text, love.window.getWidth()/2-love.graphics.getFont():getWidth(text)/2, love.window.getHeight()-60)

	
    love.graphics.setFont(font[18])
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(love.timer.getFPS(), 0, 0)
    love.graphics.print(the.player.ship:getCargoValue(), 0, 40)
end