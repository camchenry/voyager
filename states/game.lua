game = {}

function game:init()
    -- the system will be changed to match whichever system the player is in
    the.system:load(the.player.location)

    self.HUD = HUD:new()
    self.HUD:addWidget(Radar:new())

    self.selectedObject = nil

    self.translateX = 0
    self.translateY = 0

    local ship = the.system:addEntity(Ship:new())
    ship.body:setPosition(0, 0)
	
	
	self.starQuad = love.graphics.newQuad(0, 0, love.window.getWidth()*2, love.window.getHeight()*2, 256, 256)
	self.nebulaQuad = love.graphics.newQuad(0, 0, love.window.getWidth(), love.window.getHeight(), love.window.getWidth(), love.window.getHeight())
	self.starImages = {}
	for i = 1, 2 do
		self.starImages[i] = love.graphics.newImage('img/starField'..i..'.png')
		self.starImages[i]:setWrap('repeat')
	end
	
	
	--self.starQuad = love.graphics.newQuad(0, 0, love.window.getWidth()*4, love.window.getHeight()*4, love.window.getWidth()*2, love.window.getHeight()*2)
	--[[
	self.starCanvases = {}
	for i = 1, 5 do
		self.starCanvases[i] = love.graphics.newCanvas(love.window.getWidth()*2, love.window.getHeight()*2)
		self.starCanvases[i]:setWrap('repeat')
		self.starCanvases[i]:renderTo(function()
			love.graphics.setColor(255, 255, 255)
			local w, h = self.starCanvases[i]:getDimensions()
			
			love.graphics.setPointStyle('smooth')
			
			love.graphics.setPointSize(i)
			local num = math.random(200/i, 2000/i)
			for j = 1, num do
				if j < num/3 then love.graphics.setColor(math.random(255, 204), math.random(255, 230), math.random(255, 232))
				elseif j < num*2/3 then love.graphics.setColor(math.random(255, 237), math.random(255, 227), math.random(255, 216))
				else love.graphics.setColor(math.random(255, 220), math.random(255, 200), math.random(255, 232)) end
				love.graphics.point(math.random(w)+.5, math.random(h)+.5)
			end
		end)
	end]]
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

    self.HUD:update(dt)

    self.translateX = -the.player.ship.body:getX() + love.window.getWidth()/2
    self.translateY = -the.player.ship.body:getY() + love.window.getHeight()/2
end


function game:keypressed(key, isrepeat)
    if key == "m" then
        state.switch(starmap)
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
	
	--[[
	love.graphics.setScissor(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	for i = 1, #self.starCanvases do
		if the.player.ship then
			x, y = the.player.ship.body:getPosition()
			
			local divisor = (#self.starCanvases+1-i)*15
			--x, y = math.floor(x/divisor), math.floor(y/divisor)
			local w, h = self.starCanvases[i]:getDimensions()
			x = x % w
			y = y % h
		end
		--if i > 2 then
			love.graphics.draw(self.starCanvases[i], self.starQuad, -x, -y)
		--end
	end
	]]
	
	for i = 1, #self.starImages do
		if the.player.ship then
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
	

    love.graphics.translate(self.translateX, self.translateY)
    -- things that should be translated

    love.graphics.setColor(255, 255, 255)
    -- selected object display
    if self.selectedObject ~= nil then
        local obj = self.selectedObject

        love.graphics.rectangle("line", obj.x-obj.width/2-10, obj.y-obj.height/2-10, obj.width+20, obj.height+20)
    end

    the.system:draw()
    the.player.ship:draw()

    love.graphics.origin()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setLineWidth(1)

    self.HUD:draw()

    if self.selectedObject ~= nil then
        
        

        local text = 'STELLAR DESTINATION: '..string.upper(self.selectedObject.name)
        love.graphics.setFont(fontBold[28])
        love.graphics.print(text, love.window.getWidth()/2 - love.graphics.getFont():getWidth(text)/2, 50)
        love.graphics.line(100, 150, 150, 100, love.window.getWidth()-150, 100, love.window.getWidth()-100, 150)

        local text = 'PRESS (L) TO LAND'
        love.graphics.setFont(font[24])
        love.graphics.print(text, love.window.getWidth()/2 - love.graphics.getFont():getWidth(text)/2, 100)

    elseif starmap.selectedSystem ~= nil then
        local text = 'HYPERJUMP DESTINATION: '..string.upper(starmap.selectedSystem)
        love.graphics.setFont(fontBold[28])
        love.graphics.print(text, love.window.getWidth()/2 - love.graphics.getFont():getWidth(text)/2, 50)
        love.graphics.line(100, 150, 150, 100, love.window.getWidth()-150, 100, love.window.getWidth()-100, 150)

        local text = 'PRESS (J) TO JUMP'
        love.graphics.setFont(font[24])
        love.graphics.print(text, love.window.getWidth()/2 - love.graphics.getFont():getWidth(text)/2, 100)
    else
        local text = 'LOCATION: '..string.upper(the.system.name)
        love.graphics.setFont(fontBold[28])
        love.graphics.print(text, love.window.getWidth()/2 - love.graphics.getFont():getWidth(text)/2, 50)
        love.graphics.line(100, 150, 150, 100, love.window.getWidth()-150, 100, love.window.getWidth()-100, 150)
    end
	
	love.graphics.setColor(255, 0, 0)
	love.graphics.print(love.timer.getFPS(), 5, 5)
end