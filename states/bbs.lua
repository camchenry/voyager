bbs = {}

function bbs:init()
	self.missionData = require 'data.missions'
	
	self.leaveButton = Button:new("< LEAVE", 25, love.window.getHeight()-80, nil, nil, font[32], function() state.switch(landed) end)
end

function bbs:enter()
	local bbsOptions = {}
	for k, mission in pairs(self.missionData) do
		if mission.start == the.player.planet.name then
			table.insert(bbsOptions, mission)
		end
	end
	
	self.bbsList = BBS:new(bbsOptions)
	
	-- returns mission data when accepted
	self.bbsList.returnMission = function (mission)
		game.missionController:newMission(mission)
	end
end

function bbs:update()
	self.bbsList:update()
end

function bbs:mousepressed(x, y, mbutton)
	self.bbsList:mousepressed(x, y, mbutton)
	self.leaveButton:mousepressed(x, y, mbutton)
end

function bbs:draw()
	love.graphics.setFont(fontBold[40])
    love.graphics.print(the.player.planet.name..' > BBS', 25, 25)

	self.leaveButton:draw()
	self.bbsList:draw()
end