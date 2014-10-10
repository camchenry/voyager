game = {}

function game:init()
	self.missionController = MissionController:new()

    -- by setting the game up with a reset, it ensures that resetting will 
    -- take the game back to the original state
    self:reset()

    MOUSE_VALUE = 0
    MOUSE_SCALE = 0.01
end

function game:reset()
    self.HUD = HUD:new()

    self.hullDisplay = HullDisplay:new()
    self.HUD:addWidget(self.hullDisplay)

    self.navigation = Navigation:new()
    self.HUD:addWidget(self.navigation)

    self.speedDisplay = SpeedDisplay:new()
    self.HUD:addWidget(self.speedDisplay)

    self.radar = Radar:new()
    self.HUD:addWidget(self.radar)

    self.collision = Collision:new()
    assert(self.collision ~= nil)
    assert(Collision ~= nil)
    assert(self.collision.beginContact ~= nil)

    the.economy = Economy:new()
    for i=1, 10 do
        the.economy:update()
    end

    self.starBackground = StarBackground:new()
end

-- reset specifically for pause menu, because the screen resolution can change
function game:pauseReset()
    self.starBackground = StarBackground:new()

    if not the.player.ship.destroyed then
        self.translateX = -the.player.ship.body:getX() + love.window.getWidth()/2
        self.translateY = -the.player.ship.body:getY() + love.window.getHeight()/2
    end

    self.radar:update(love.timer.getDelta())
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
            self.navigation:setText("ENGAGING HYPERJUMP DRIVE", "T-"..round(the.player.ship.jumpCountdown, 1))
        else
            self.navigation:setText("EXECUTING HYPERJUMP")
        end
    elseif self.selectedObject ~= nil then
        self.navigation:setText('STELLAR DESTINATION: '..string.upper(self.selectedObject.name), 'PRESS (L) TO LAND')

    elseif starmap.selectedSystem ~= nil then
        self.navigation:setText('HYPERJUMP DESTINATION: '..string.upper(starmap.selectedSystem), 'PRESS (J) TO JUMP')
    else
        self.navigation:setText("", "")
    end

    self.HUD:update(dt)
end


function game:keypressed(key, isrepeat)
    love.keyboard.setKeyRepeat(false)
    the.system:keypressed(key, isrepeat)
    if not the.player.ship.destroyed then
        the.player.ship:keypressed(key, isrepeat)
    end

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
                    game.missionController:update()
    				state.switch(landed)
    			end
            else
                self.selectedObject = the.system:closestObject(the.player.ship.body:getX(), the.player.ship.body:getY(), 200)
            end
        end
    end

    if key == "escape" then
        if self.selectedObject ~= nil then
            self.selectedObject = nil
        else
            state.push(pause)
        end
    end
end

function game:mousepressed(x, y, button)
    if button == "l" then
        self.selectedObject = the.system:closestObject(x-self.translateX, y-self.translateY)
    end

    if button == "wu" then
        MOUSE_VALUE = MOUSE_VALUE + MOUSE_SCALE
    elseif button == "wd" then
        MOUSE_VALUE = MOUSE_VALUE - MOUSE_SCALE
    end
end

function game:draw()
    love.graphics.setColor(255, 255, 255)

    self.starBackground:draw()
	
    -- things that should be translated
    love.graphics.translate(math.floor(self.translateX), math.floor(self.translateY))

    -- selected object display
    if self.selectedObject ~= nil then
        local obj = self.selectedObject

        love.graphics.setColor(255, 255, 255, 127)
        love.graphics.rectangle("line", obj.x-obj.width/2-10, obj.y-obj.height/2-10, obj.width+20, obj.height+20)
    end

    the.system:draw()

    love.graphics.origin()

    -- drawing the player with a floored translation causes the ship to look jittery
    love.graphics.translate(self.translateX, self.translateY)

    if not the.player.ship.destroyed then
        the.player.ship:draw()
    end

    love.graphics.origin()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)

    fx.draw()

    self.HUD:draw()
    
    if config.debug then
        love.graphics.setFont(font[18])
	    love.graphics.setColor(255, 255, 255)
	    love.graphics.print(love.timer.getFPS(), 0, 0)
        love.graphics.print(MOUSE_VALUE, 0, 20)
        love.graphics.print(dump(the.player.alignment), 0, 40)
    end
end