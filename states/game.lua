game = {}

function game:init()
    -- the system will be changed to match whichever system the player is in
    the.system:load(the.player.location)

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

function game:enter()
    
end

function game:update(dt)
    the.system:update(dt)

    the.player.ship:update(dt)

    self.translateX = -the.player.ship.body:getX() + love.window.getWidth()/2
    self.translateY = -the.player.ship.body:getY() + love.window.getHeight()/2
end


function game:keypressed(key, isrepeat)
    if key == "m" then
        state.switch(starmap)
    end

    if key == "j" then
        the.player:jump()
    end

    if key == "l" then
        if self.selectedObject ~= nil then
            the.player.planet = self.selectedObject
            self.selectedObject = nil
            state.switch(landed)
        end
    end
end

function game:mousepressed(x, y, button)
    if button == "l" then
        self.selectedObject, self.dist = the.system:closestObject(x-self.translateX, y-self.translateY)
    end
end

function game:draw()
    love.graphics.setColor(255, 255, 255)

    -- things that shouldn't be translated

    love.graphics.print(the.system.name)

    love.graphics.translate(self.translateX, self.translateY)
    -- things that should be translated
    
    the.system:draw()

    -- selected object display
    if self.selectedObject ~= nil then
        local obj = self.selectedObject

        love.graphics.rectangle("line", obj.x-obj.width/2-5, obj.y-obj.height/2-5, obj.width+5, obj.height+5)
    end

    the.player.ship:draw()
end