gameOnline = {}

player = {
    name = 'Nuthen',
}

function gameOnline:init()

end

function gameOnline:enter(pre, name, ip, port)
	love.graphics.setBackgroundColor(33, 48, 148)
	
	player.name = 'Nuthen_'..math.random(22)
	
	
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

    self.timer = 0
	self.clients = 0
end

function gameOnline:update(dt)
    self.timer = self.timer + dt -- Time since client began running

    local event = self.host:service() -- Checks for an event in the queue
    if event then
	
		self.peer = event.peer
		self.eventData = event.data
		
        if event.type == 'connect' then
            self.connectionVerified = true
			event.peer:ping_interval(500) -- Sets how often the client sends a packet to the server to verify connection, in ms
			
			event.peer:send('nm|' .. player.name)
            --event.peer:send(dump(player))
			--local playerStr = tableToString(player)
			--event.peer:send(playerStr)
        end

        if event.type == 'receive' then
			-- incoming message
			local str = event.data
			self.chat:addMessage(str)
        end
    end
	
	--[[
    -- only send updates if you are moving and it has been more than 20ms since the last update
    if love.keyboard.isDown("w", "a", "s", "d") then
        -- 0.100 = 100ms
        if self.timer > 0.020 then
            self.server:send(dump(player))
            self.timer = 0
        end
    end
	]]
end

function gameOnline:draw()
	love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font[18])

    if self.connectionVerified then
        love.graphics.print("Connected to: "..tostring(self.server).."\nStatus: "..self.server:state(), 5, 5)
    end
    
    if self.eventData ~= "" and self.peer then
        love.graphics.print("Got message: "..self.eventData.." \nfrom "..tostring(self.peer:index()), 5, 50)
    end
	
	--love.graphics.print('Client Number:'.. self.clients, 5, 130)
	if self.peer then
		love.graphics.print('Client Number:'.. tostring(self.peer), 5, 130)
	end
	
	love.graphics.print("Ping: "..tostring(self.server:round_trip_time()).."ms", 5, love.window.getHeight()-25)
	--love.graphics.print('Sent Data: '..tostring(self.host:total_sent_data()/1000000)..'MB', 5, love.window.getHeight()-55)
	--love.graphics.print('Received Data: '..tostring(self.host:total_received_data()/1000000)..'MB', 5, love.window.getHeight()-85)
	
	love.graphics.print('Sent Data: '..tostring(self.host:total_sent_data())..'B', 5, love.window.getHeight()-55)
	love.graphics.print('Received Data: '..tostring(self.host:total_received_data())..'B', 5, love.window.getHeight()-85)
--[[
    for i, entity in pairs(gameOnline.entities) do
        if i ~= "type" then 
            love.graphics.rectangle("fill", entity.x, entity.y, 25, 25)
        end
    end

    love.graphics.rectangle("fill", player.x, player.y, 25, 25)
]]
	
	self.chat:draw()
end

function gameOnline:quit()
	-- send a disconnect call to the server
	--self.server:disconnect()
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