game = {}

server = {
    ip = "*",
    port = "22122",
}


function game:init()
    game.entities = {}

    self.host = enet.host_create(server.ip..":"..server.port)

    if self.host == nil then
        error("couldn't initialize host, there is probably another server running on that port")
    end
	
	self.host:compress_with_range_coder()

    self.timer = 0
	
	self.started = false
	
	self.tick = 2
	self.tock = 0
	
	self.lastEvent = nil
	self.peer = nil
end

function game:update(dt)
    self.timer = self.timer + dt

    -- check some events, 100ms timeout
    local event = self.host:service(100)

    if event then
		event.peer:ping_interval(10000)
        self.lastEvent = event
		self.peer = event.peer

        -- someone has connected to the server
        if event.type == "connect" then
			--local id = self.nextID
			--table.insert(self.connectedID, id)
			
			--[[
			self.nextID = self.nextID+1
			local data = {
				type = 'id',
				id = id,
				clients = #self.connectedID,
			}
			
			event.peer:send(dump(data))
			]]
			
			local index = event.peer:index()
			self.entities[index] = {}
			event.peer:send("Welcometoserv1")
			event.peer:send('cn|' .. index)
        end
		
        -- received data from a client
        if event.type == "receive" then
            -- this will either return the event data and load it into
            -- sentData, or it will make sentData an empty string
            --sentData = assert(loadstring("return " .. event.data or ""))()

            --if sentData ~= nil then
                --if sentData.type == "move" then
				--end
            --end
			
			local index = event.peer:index()
			if string.find(event.data, 'nm|') == 1 then -- True if it is name data 
				self.entities[index].name = string.gsub(event.data, 'nm|', '')
			elseif string.find(event.data, 'tx|') == 1 then -- True if a message
				local name = self.entities[index].name or 'User_' .. index
				local str = string.gsub(event.data, 'tx|', '')
				self.host:broadcast(name .. ': ' .. str)
			elseif string.find(event.data, 'cp|') == 1 then -- True if a player position
				self.host:broadcast(event.data)
			end
        end
		
		-- called when a client disconnects from the server
		if event.type == 'disconnect' then
			local index = event.peer:index()
			self.entities[index] = nil
		end
		
		--[[
		
        -- every 1ms, send out an up-to-date entity list
        if self.timer > 0.001 then -- This should be more like 30 ms
            self.timer = 0
            --host:broadcast(dump(game.entities))
        end
		]]
    end
end

function game:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.setFont(font[24])
	
    love.graphics.print('Running server on ' .. server.ip .. ':' .. server.port, 5, 5)
	love.graphics.print('Server Time: '..math.floor(self.timer), 5, 25)

    if self.lastEvent then
        local msg = "Last message: "..tostring(self.lastEvent.data).." from "..tostring(self.peer:index())
        love.graphics.print(msg, 5, 65)
    end

	
	for i = 1, 6 do -- checks through all possible number of players
		local entity = self.entities[i] or {}
		if entity.name then
			love.graphics.print(entity.name, 5, 105 + i*22)
		end
	end
	
	--[[
    love.graphics.print("Entities: "..tostring(#game.entities), 5, 35)
	
    for i, entity in pairs(game.entities) do
        if i ~= "type" then
            love.graphics.rectangle("fill", entity.x, entity.y, 25, 25)
        end
    end
	]]
end