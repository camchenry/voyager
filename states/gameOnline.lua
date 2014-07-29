gameOnline = {}

player = {
    name = 'Nuthen',
}

function gameOnline:init()
	the.system = self.systems["Sol"]

    the.system:addEntity(the.player.ship)
	
	
	self.entities = {}
end

function gameOnline:loadSystems()
	self.systems = {}

    local starSystems = require 'data.systems'

    for systemName, systemData in pairs(starSystems) do
        local system = StarSystem:new(systemName)

        -- add all objects
        for k, object in pairs(systemData.objects) do
            local class = _G[object.class]
            local newObject = class:new()
            newObject.name = object.data.name
            newObject.x = object.data.x
            newObject.y = object.data.y

            system:addObject(newObject)
        end

        self.systems[systemName] = system
    end
end

function gameOnline:enter(pre, name, ip, port)
	--love.graphics.setBackgroundColor(33, 48, 148)
	
	player.name = the.player.name
	
	
	self.chat = Chat:new() -- Chat box

	--player.name = name

	self.entities = {}
    self.host = enet.host_create()
    self.server = self.host:connect("localhost:22122")
	--self.server = self.host:connect(ip..':'..port)
	
	self.host:compress_with_range_coder() -- Recognizes patterns in sent/received stringdata to compress size. Higher performance?
	
    self.connectionVerified = false
    
    self.eventData = nil
    self.peer = nil
	
	self.clientNumber = nil

    self.timer = 0
	
	self.lastSent = {x = nil, y = nil}
	self.lastSentTime = 0
end

function gameOnline:update(dt)
	the.system:update(dt)

	self.chat:update(dt)
	
	
	-- Client code
    self.timer = self.timer + dt -- Time since client began running

    local event = self.host:service() -- Checks for an event in the queue
    if event then
		self.peer = event.peer
		self.eventData = event.data
		
        if event.type == 'connect' then
            self.connectionVerified = true
			event.peer:ping_interval(500) -- Sets how often the client sends a packet to the server to verify connection, in ms
			
			event.peer:send('nm|' .. player.name)
        end

        if event.type == 'receive' then
			-- incoming message
			local str = event.data
			
			local index = event.peer:index()
			if string.find(str, 'cn|') == 1 then -- True if it is name data 
				self.clientNumber = string.gsub(str, 'cn|', '')
			elseif string.find(str, 'cp|') == 1 then -- True if a message
				local str = string.gsub(str, 'cp|', '')
				local entityInfo = stringToTable(str)
				
				local clientNumber = entityInfo[1]
				local x = entityInfo[2]
				local y = entityInfo[3]
				
				--if clientNumber ~= self.clientNumber then
					self.entities[clientNumber] = {x = x, y = y}
				--end
			else
				self.chat:addMessage(str)
			end
        end
    end
	
	
	if self.timer - self.lastSentTime >= .03 then -- close to every 30ms send position data
		self.lastSentTime = self.timer
		local x, y = the.player.ship.body:getPosition()
		
		if self.clientNumber then
			local str = 'cp|' .. self.clientNumber .. ' ' .. x .. ' ' .. y -- don't actually need to send client number here
		
			self.peer:send(str)
		end
	end
end

function gameOnline:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.push()

    love.graphics.print(the.system.name)

    local x = -the.player.ship.body:getX() + love.window.getWidth()/2 - the.player.ship.width/2
    local y = -the.player.ship.body:getY() + love.window.getHeight()/2 - the.player.ship.height/2
    love.graphics.translate(x, y)

    the.system:draw()
	love.graphics.pop()
	
    love.graphics.setFont(font[18])
	
	self.chat:draw()

	
	-- Draw other player ships
	for i = 1, 6 do
		local entity = self.entities[i] or {}
		if entity.x then
			love.graphics.setColor(212, 127, 127)
			love.graphics.rectangle("fill", entity.x, entity.y, 100, 300)
		end
	end
	
	-- Server status information
    if self.connectionVerified then
        love.graphics.print('Connected to: ' .. tostring(self.server), 5, 5)
    end
		love.graphics.print('Status: ' .. self.server:state(), 5, 25)
    
    if self.eventData then
        love.graphics.print('Got message: ' .. self.eventData, 5, 45)
    end
	
	if self.clientNumber then
		love.graphics.print('Client Number: ' .. tostring(self.clientNumber), 5, 65)
	end
	
	local text = 'Ping: ' .. tostring(self.server:round_trip_time()) .. 'ms'
	love.graphics.print(text, 5, 95)
	
	local text = 'Sent Data: ' .. tostring(self.host:total_sent_data()/1000000) .. 'MB'
	love.graphics.print(text, 5, 115)
	
	local text = 'Received Data: ' .. tostring(self.host:total_received_data()/1000000) .. 'MB'
	love.graphics.print(text, 5, 135)
end

function gameOnline:quit()
	-- send a disconnect call to the server
	self.server:disconnect()
	self.host:flush()
end


function gameOnline:textinput(text)
	self.chat:textinput(text)
end

function gameOnline:keypressed(key)
	self.chat:keypressed(key, isrepeat)
end


-- Send a string to the server
function gameOnline:sendToServer(str)
	if self.peer then
		--error(str)
		self.peer:send(str)
	else
		error('Not connected to a server!')
	end
end